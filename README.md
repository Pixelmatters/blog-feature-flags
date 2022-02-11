<h1 align="center">
  Blog - Feature Flags
</h1>

<h3 align="center">
  A simple feature-flags code for iOS, made to a Pixelmatters <a href="https://www.pixelmatters.com/blog/feature-toggle-a-hands-on-guide-to-start-using-it" target="_blank">blog article</a>.
</h3>

<p align="center">
Feature toggles are one of the most relevant mechanisms used to modify features in real-time without changing code. Developers can test different changes on a specific group of users before making them available to everyone, being essential in mitigating risks.
</p>

<p align="center">
  <a href="https://github.com/Pixelmatters/blog-feature-flags/blob/main/LICENSE">
    <img src="https://img.shields.io/npm/l/@pixelmatters/blog-feature-flags" alt="blog-feature-flags license." />
  </a>
  <a href="https://twitter.com/intent/follow?screen_name=pixelmatters_">
    <img src="https://img.shields.io/twitter/follow/pixelmatters_.svg?label=Follow%20@pixelmatters_" alt="Follow @pixelmatters_" />
  </a>
</p>

## 🚀 Get Up and Running

First of all, you must add the [Firebase](https://firebase.google.com/docs/ios/setup) to your project and download the GoogleService-Info.plist to obtain your Firebase Apple platforms config file, without this step you will not be able to use the simple feature-flags code for iOS.

### Firebase Remote Config

The Remote Config allows you to change the behavior and appearance of your app without publishing an app update.

[![Remote Config](https://img.youtube.com/vi/_CXXVFPO6f0/0.jpg)](https://www.youtube.com/watch?v=_CXXVFPO6f0)

The next step is to configure on Firebase the keys that you would like to take control of remotely. There are some rules and conditions to configure the keys correctly that can be verified on [Remote Config Parameters and Conditions](https://firebase.google.com/docs/remote-config/parameters).

Considering that everything was set up correctly, you can import the simple feature-flags code for your project.

## 📝 License

Licensed under the [MIT License](./LICENSE).
