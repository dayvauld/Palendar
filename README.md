#  Palendar

A calendar with your favorite pals! Dogs or Cats, you decide. Or just mix them up!

<hr>

A couple things of note:<br>
- The UI is built in SwiftUI. And the app is following a basic MVVM architecture and uses Combine for binding data/state. 
- No external dependencies are used.
- The app supports horizontal and vertical layouts, varying screen sizes (iPhone/iPad), light/dark mode and scaling font sizes. 
- A number of unit tests are found in the PalendarTests folder.

A couple areas for improvement:
- Image caching/management could be added either through a NSCache or third-party library.
- Data/API caching could be added through a repository or similar pattern.
- Strings could be localized and abstracted into their own file.
- Storing URLs/domains and other important strings in a Constants file or in build settings/.plist. 

<hr>
