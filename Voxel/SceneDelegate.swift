import UIKit
import DesignSystem
import Swinject
import VoxelAuthentication
import VoxelCore
import VoxelLogin
import VoxelSettings

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var container: Container!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setupContainer()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        UINavigationController.styleVoxel()
        
        let navigationController = UINavigationController(
            rootViewController: setupInitialViewController()
        )
        
//      navigationController.styleVoxel()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        subscribeToLogin()
        subscribeToLogout()
    }
    
    private func setupInitialViewController() -> UIViewController {
        let authService = AuthServiceLive()
        
        if authService.isAuthenticated {
            return setupTabBar()
        } else {
            return setupPhoneNumberController()
        }
    }
    
    private func setupTabBar() -> UIViewController {
        TabBarController(container: container)
    }
    
    private func setupPhoneNumberController() -> UIViewController {
        let authService = AuthServiceLive()
        let viewModel = PhoneNumberViewModel(container: container)
        
        let phoneNumberController = PhoneNumberViewController()
        phoneNumberController.viewModel = viewModel
        
        return phoneNumberController
    }
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension SceneDelegate {
    private func subscribeToLogin() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didLoginSuccessfully),
            name: Notification.Name(AppNotification.didLoginSuccessfully.rawValue),
            object: nil
        )
    }
    
    @objc
    private func didLoginSuccessfully() {
        let navigationController = window?.rootViewController as? UINavigationController
        navigationController?.setViewControllers([setupTabBar()], animated: true)
    }
}

// MARK: Logout

extension SceneDelegate {
    private func subscribeToLogout() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didLogout),
            name: Notification.Name(AppNotification.didLogout.rawValue),
            object: nil
        )
    }
    
    @objc
    private func didLogout() {
        let navigationController = window?.rootViewController as? UINavigationController
        navigationController?.setViewControllers([
            setupPhoneNumberController()
        ], animated: true)
    }
}

extension SceneDelegate {
    private func setupContainer() {
        container = Container()
        AppAssembly(container: container).assemble()
        
//        let assembler = AppAssembly()
//        assembler.assemble()
    }
}
