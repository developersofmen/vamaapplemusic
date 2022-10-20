# VamaAppleMusic
The app fetches data from a network resource and renders the content in a fashionable way across different devices. This allows Vama to review your skills as a Software Engineer and suitability for the projects ahead. Your task will be to review the requirements, come up with a plan and execute that plan to build the app.

# Data Source
https://rss.applemarketingtools.com/

# Platform
iPhone devices running on iOS 13 or above

# Tools
Xcode 14.0.1

# Programming Language
Swift 5.7

# 3rd party libraries
VamaAppleMusic has RealM 3rd party library for local database. It has been added via cocoapods

# Steps to install dependency via pods
- Go to the project directory in terminal
- Execute command pod install
- Open the VamaAppleMusic.xcworkspace

# UI
- UI is developed using programming without using storyboard/xib/interface builder
- UI is developed using Autolayout

# Quick UI reference

        MainCoordinator
                |
                | 
                |
        AlbumListController ---> UIView --> UICollectionView
                |                                   |
                |                                   |--> AlbumListCell
                |
                | 
                |
        AlbumDetailController : UIView
                                   |
                                Subviews
                                
# Data Flow
- Show data from local database
- Make remote network call to fetch the updated data
- Sync local database with the updated data from the remote database
- Callback to the UI and it will show the data from the local database

# Architecture
- This app is developed using MVVM architecture with the completion handlers. Binding, Reactive and Observer pattern is not used due to the nature of the demo app was very simple.

# Design Patterns
Design patterns should in this demo
- Closures/Callbacks
- Repository 
- Coordinator: A single coordinator with the file name "MainCoordinator.swift" is being used to handle the app navigation. As this app has only two screens and not the complex navigation flow that's why we have used only one coordinator which is responsible to handle root navigation and redirection to the detail screen. For the complex navigation flow we can create multiple child coordinator and distribute the responsibity between them.

# Principles 
- The Single Responsibility Principle
- DRY Principle
- Data abstraction and Encapsulation 
