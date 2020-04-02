# CustomerInvite

## Dependencies
This project uses RXSwift libraries that are included in the repository (*Podfile*). You should always open from the **.xcworkspace** file.
You need the CocoaPods dependency manager and all the info can be obtained in: https://cocoapods.org. To install the dependecies you can run the command:

```pod install```

## Xcode version
This was built using **Xcode Version 11.4 (11E146)**. Using previous versions could result in random bugs.

## Export
There's a **export.txt** example file included in the root of this project

## How it works
* The app should auto download the file and present in form of a table in the main screen.
* Clicking on **import** should download the file and transform in data again.
* On top right there's a button to show the original list and the filtered list.
* Clicking on **export** should export the current exhibited list in a AirDropable form.
* It uses the default timeout for operations.

## Images
Some images of how it should looks like
![Complete list](https://github.com/brunomyrrha/CustomerInvite/blob/master/tutorialImages/loading.png)
![Filtered list](https://github.com/brunomyrrha/CustomerInvite/blob/master/tutorialImages/filter_list.png)
![Loading screen](https://github.com/brunomyrrha/CustomerInvite/blob/master/tutorialImages/loading.png)
![Timeout screen](https://github.com/brunomyrrha/CustomerInvite/blob/master/tutorialImages/timeout.png)
