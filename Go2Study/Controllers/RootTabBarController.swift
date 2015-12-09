//
//  RootTabBarController.swift
//  Go2Study
//
//  Created by Ashish Kumar on 09/12/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit
import CoreData

class RootTabBarController: UITabBarController, ManagedObjectContextSettable {
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        let peopleViewController = PeopleViewController()
//        peopleViewController.managedObjectContext = managedObjectContext
        let peopleNavigationController = UINavigationController(rootViewController: peopleViewController)
        peopleNavigationController.tabBarItem = UITabBarItem(title: "People", image: UIImage(assetIdentifier: .TabBarPeople), selectedImage: UIImage(assetIdentifier: .TabBarPeopleSelected))
        
        let calendarNavigationController = UINavigationController()
        calendarNavigationController.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(assetIdentifier: .TabBarCalendar), selectedImage: UIImage(assetIdentifier: .TabBarCalendarSelected))
        
        let messagesNavigationController = UINavigationController()
        messagesNavigationController.tabBarItem = UITabBarItem(title: "Messages ", image: UIImage(assetIdentifier: .TabBarMessages), selectedImage: UIImage(assetIdentifier: .TabBarMessagesSelected))
        
        let settingsNavigationController = UINavigationController()
        settingsNavigationController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(assetIdentifier: .TabBarSettings), selectedImage: UIImage(assetIdentifier: .TabBarSettingsSelected))
        
        let tabBarViewControllers = [peopleNavigationController, calendarNavigationController, messagesNavigationController, settingsNavigationController]
        setViewControllers(tabBarViewControllers, animated: true)
    }

}
