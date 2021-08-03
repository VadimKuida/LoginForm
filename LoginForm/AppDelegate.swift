//
//  AppDelegate.swift
//  LoginForm
//
//  Created by Вадим Куйда on 21.10.2020.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift //1 Pod для смещения объектов под клавиатуру
import UserNotifications
import Network

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var itemTimeArray = [Logtimer]()
    var itemTimeArrayUser = [Login]()
    var divToken: String!
    var userCore: String!

    var window: UIWindow?

    var scheme: String!
    var path: String!
    var query: String!
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetConnectionMonitor")

   


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        Thread.sleep(forTimeInterval: 2.0) //Timer Launch screen
        registerForPushNotifications()

//        IQKeyboardManager.shared.enable = true //1 Активация
        
        
        IQKeyboardManager.shared.enable = true

        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        monitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status == .satisfied {
                print("Internet connection is on.")
//                self.onlineCheck()
            } else {
                print("There's no internet connection.")
                self.onlineCheck()

            }
        }

        monitor.start(queue: queue)

//        IQKeyboardManager.shared.shouldShowTextFieldPlaceholder = false
//        IQKeyboardManager.shared.shouldHidePreviousNext = false
        
        return true
     
    }
    
    func onlineCheck() {
        DispatchQueue.main.async {
        let vc = OnlineCheck()
//        let navController = UINavigationController(rootViewController: vc)
//        navController.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.window?.rootViewController?.present(vc, animated: true, completion: nil)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        
    }
    
    


    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
       
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("111")
    }
    
    

    
    
    // MARK: - Core Data save context
    
    func applicationWillTerminate(_ application: UIApplication) {
//        self.saveContext()
        print("444")
   
        loadItems()
      
        upadteTimeClose()
//        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
//        tableStepController.stopUpdateLocal()
    
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "Model")
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
    
//    func stopTimeUpdate() {
//        delegate?.stopUpdate(self)
//    }

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
    
    func upadteTimeClose () {
        self.itemTimeArray.forEach({ book in
//            print(book.topicID)
            if (book.dateTimeEnd == nil) {
                book.dateTimeEnd = Date()
                book.typeAction = "Finish"
                saveContext()
            }
        })
    }
    
    

    func loadItems() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request : NSFetchRequest<Logtimer> = Logtimer.fetchRequest()
        do {
            itemTimeArray = try context.fetch(request)
        } catch {
            print("Error")
        }
    }
    
    
    

    
    func registerForPushNotifications() {
      //1
        UNUserNotificationCenter.current()
          .requestAuthorization(
            options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
          }
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
        
    }
    
    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let token = tokenParts.joined()
        
        self.divToken = token
//      print("Device Token: \(token)")
    }
    
    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
      print("Failed to register: \(error)")
    }
    
}

