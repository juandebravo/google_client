
This gem can be used to get access to a specific set of Google APIs.

# Installation

    gem install google_client

# Features

* Rails Engine to launch OAuth mechanism
* Refresh OAuth token
* Google Calendar
  * Fetch the list of user calendars
  * Create a new calendar
  * Retrieve a specific calendar
  * Fetch calendar events, filtering by specific event id, time interval (and more coming)
  * Delete calendar
  * Create event
  * Delete event
* Google Contacts
  * Fetch user contacts

# Getting started

Any request that may be done on behalf of the user needs a valid authentication token:

    require "gogole_client"
    user = GoogleClient::User.new "user-authentication-token"

    # Get user contacts
    contacts = user.contacts

    # Get user calendars
    calendars = user.calendars

    # Get a specific user calendar
    calendar = user.calendars("<calendar-id>")

    # Fetch calendar events
    events = calendar.events

    # Create calendar
    calendar = user.create_calendar({:title => "my-new-calendar", 
                          :details => "Hello world", 
                          :timezone => "Spain", :location => "Barcelona"})

    # ...

Take a look on the [user.rb](blob/master/lib/google_client/user.rb) file to check the available methods

# Roadmap

* Enhance filters
* Handle contacts
    * Create a new contact
    * Delete an existing contact
    * Update a contact
* Add XML format support. Currently (except the OAuth requests) all the requests/responses are JSON encoded. It may be nice to add support for XML too.

# Note on Patches/Pull Requests

* Fork the project
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  * If you want to have your own version, that is fine but bump version in a commit by itself so I can ignore when I pull
* Send me a pull request. Bonus points for topic branches.

# License

    The MIT License

    Copyright (c) 2011 Juan de Bravo

    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the
    'Software'), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.