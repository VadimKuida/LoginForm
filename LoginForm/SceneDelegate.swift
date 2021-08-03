//
//  SceneDelegate.swift
//  LoginForm
//
//  Created by Вадим Куйда on 21.10.2020.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var activeUserManager = ActiveUserManager()
    var itemTimeArray = [Login]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var userCore: String = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        if let urlContext = connectionOptions.urlContexts.first {
                
            let sendingAppID = urlContext.options.sourceApplication
            let url = urlContext.url
            print("source application = \(sendingAppID ?? "Unknown")")
            print("url = \(url)")
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).

        let userCoreStr = nameUserCore()
//        print(userCoreStr)
        activeUserManager.performActiveUser(loginLet: userCoreStr, action: 0)
        activeUserManager.performActiveUserSeance(loginLet: userCoreStr, action: 3)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {

        let userCoreStr = nameUserCore()
//        print(userCoreStr)
        activeUserManager.performActiveUser(loginLet: userCoreStr, action: 1)
        userNotificationCenter.removeDeliveredNotifications(withIdentifiers: ["testNotification"])
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: ["testNotification"])

        
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
      
        let userCoreStr = nameUserCore()
//        print(userCoreStr)
        activeUserManager.performActiveUser(loginLet: userCoreStr, action: 0)
        if K.startStep {
            sendNotification()
        }
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
//        loadItems()
//        let userCoreStr = nameUserCore()
//        print(userCoreStr)
//        activeUserManager.performActiveUser(loginLet: userCoreStr, action: 1)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        

        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
   
        let userCoreStr = nameUserCore()
        activeUserManager.performActiveUser(loginLet: userCoreStr, action: 0)
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
    }
    
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
           if let url = URLContexts.first?.url {
                K.rederectUrl = nil
                print(url)
                let urlStr = url.absoluteString //1
               // Parse the custom URL as per your requirement.
                let component = urlStr.components(separatedBy: "check=") // 2
                if component.count > 1, let appId = component.last { // 3
                   print(appId)
                    if appId == "5c9f56" {
                        K.mailCheck = true
//                        NoCheck.setNeedsDisplay()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotifMaill"), object: nil)
                        
                    }

//                let userCoreStr = nameUserCore()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif1"), object: nil)
                    
 
//                   let topViewController = self.window?.rootViewController as? UINavigationController
//                   let currentVC = topViewController?.topViewController as? ViewController
                   
               }
           }
       }
    
    

    

    func loadItems() {
        let request : NSFetchRequest<Login> = Login.fetchRequest()
        do {
            itemTimeArray = try context.fetch(request)
        } catch {
            print("Error")
        }
    }
    
    func nameUserCore() -> String
    {
        loadItems()
        if let i = itemTimeArray.firstIndex(where: {$0.user != nil }) {
            self.userCore = itemTimeArray[i].user!
            }
        return self.userCore
    }
    
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Внимание!"
        notificationContent.body = "У тебя остался активный замер, не забудь про него!"
//        notificationContent.badge = NSNumber(value: 1)
        
        if let url = Bundle.main.url(forResource: "dune",
                                    withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                            url: url,
                                                            options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 400,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in

            if let error = error {
                print("Notification Error: ", error)
            }
        }
      
    }

}



extension SceneDelegate: ActiveUserManagerDelegate {
    func didShowGroupUser(_ Content: ActiveUserManager, content: [ListAdminUser]) {
        
    }
    
    func didShowGroup(_ Content: ActiveUserManager, content: [ListAdmin]) {
        
    }
    
    func didUpdateGroup(_ Content: ActiveUserManager, content: GroupUpdate) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
            if content.success == 1 {
//            self.dismiss(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            }
        }
        
    }
    
    func didActiveUserSeance(_ Content: ActiveUserManager, content: ActiveUser) {
        
    }
    
    func didActiveUser(_ Content: ActiveUserManager, content: ActiveUser) {
        
    }
    
}
