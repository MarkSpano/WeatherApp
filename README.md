# WeatherApp

The following was the state of the app at the time limit.

What it does:

- gets and displays all the requested weather parameters
- gets and displays weather icon
- matches the Figma designs (although they don't describe the actual device size)
- uses MVVM, Swift and SwiftUI
- the search bar works using either a city name or a zip code

What it doesn't do:

- handle search errors
- store the token in the user defaults
- store the persisted city in the user defaults for reloading on launch
- too many "!" in the code.  Needs better error handling for most of those.

Other criticisms:

- there is a lot of repeated code for text fields that could have been put into a common style.  This would also remove most of the hard-coded sizes and color values.
- the app has a warning about publishing changes from a background thread.  It works but that needs to be fixed.
