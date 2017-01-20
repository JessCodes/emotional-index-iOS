# Emote Me
Emote Me iOS is the companion to the [Ruby on Rails web app](https://github.com/JessCodes/emotional-index) built using Swift.  This app looks at a photo of the user and analyzes the user's emotions. Based on the emotion and user preferences, the app shows the user a YouTube video or gif or sends an inspiring text to improve the user's mood or keep the mood high.

## Getting Started

If you want to clone down the repo, you will need to run this command in your terminal to get the proper file installation:

    pod install

You will also need to provide your personal [Google Cloud Vision API](https://cloud.google.com/vision/) key in a property list file titled ApiKeys.

If you want to log into the Swift app, use the below email/password information to sign in as a dummy user to register emotions and see resources:

email: "lucas@walter.io"

password: "password"


## Tech Stack Used
- Swift
    + Alamofire
    + AccessKeychain
    + Cocopods
    + Giphy API
    + Google Cloud Vision API
    + Rails API for user login, custom built
    + SwiftlyJSON
    + Twilio API
    + YouTube API
- Ruby/Ruby on Rails
    + Bower (uses JS and node JS)
    + Highcharts
    + HTML5
    + Materialize/CSS
    + Sorcery
- Heroku

## Authors
- Megan Eding
- Jess Ellison
- Anthony Tokatly
- Katee Trant
- Jen Young 

See also the list of [contributors](https://github.com/JessCodes/emotional-index-iOS/graphs/contributors) who worked on this project.
