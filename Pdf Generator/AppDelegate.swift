//
//  AppDelegate.swift
//  Pdf Generator
//
//  Created by Fetih Tunay Yetişir on 12.06.2021.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UITabBarDelegate,UITabBarControllerDelegate {

    var window: UIWindow?
    
    var tabbar:UITabBarController!
    var homeview:ViewController!
    var historyview:HistoryVC!
    var settingview:SettingVC!
    
    var ispassword = Bool()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        ispassword = false
        
         tabbar = (self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController)

        showMainTabbar(index: 0)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func showMainTabbar(index:NSInteger)
    {
        tabbar.tabBar.isTranslucent = false
        tabbar.delegate = self
        tabbar.tabBar.tintColor = UIColor.black
        tabbar.tabBar.barTintColor = UIColor.white
        let array = tabbar.viewControllers! as NSArray
        tabbar.selectedViewController = array[index] as? UIViewController
        
        //        let label = UILabel()
        //        label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 1)
        //        label.backgroundColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 0.5)
        //        tabbar.tabBar.addSubview(label)
        
        tabbar.tabBar.barTintColor = Main_Color
        
        for tab in tabbar.viewControllers!
        {
            let navigationController : UINavigationController = tab as! UINavigationController
            
            let controller:UIViewController = navigationController.viewControllers[0]
            
            var normalImg = ""
            var pressImg = ""
            
            if (controller is ViewController)
            {
                normalImg = "web"
                pressImg = "web1"
            }
            else  if(controller is HistoryVC)
            {
                normalImg = "clipboard"
                pressImg = "clipboard1"

            }
            else  if(controller is SettingVC)
            {
                normalImg = "settings"
                pressImg = "settings1"
                
            }
            
            tab.tabBarItem.image = UIImage(named: normalImg)?.withRenderingMode(.alwaysOriginal)
            tab.tabBarItem.selectedImage = UIImage(named: pressImg)?.withRenderingMode(.alwaysOriginal)
            
        }
        
        for tabbarItem in tabbar.tabBar.items!
        {
            //tabbarItem.title = ""
            //tabbarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
           // tabbarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -15)
            
            tabbarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont(name: "Rubik-Medium", size: 13.0) as Any], for: .normal)
            tabbarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont(name: "Rubik-Medium", size: 13.0) as Any], for: .selected)
        }
        

        
        self.window?.rootViewController = tabbar
        self.window?.makeKeyAndVisible()
    }


    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Pdf_Generator")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

