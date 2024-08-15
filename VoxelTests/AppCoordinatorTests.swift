import XCTest
import Swinject
import VoxelAuthentication
import VoxelLogin
@testable import Voxel

final class AppCoordinatorTests: XCTestCase {
    
    private var coordinator: AppCoordinator!
    private var navigationController: UINavigationController!
    private var container: Container!
    private var authService: AuthServiceMock!
    
    override func setUp() {
        navigationController = UINavigationController()
        container = Container()
        authService = AuthServiceMock()
        
        container.register(AuthService.self) { _ in
            self.authService
        }
        
        coordinator = AppCoordinator(
            navigationController: navigationController,
            container: container
        )
    }
    
    func test_whenUserIsAuthenticated_thenPresentTabBar() {
        // given
        authService.isAuthenticated = true
        // when
        coordinator.start()
        // then
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is TabBarController)
    }
    
    func test_whenUserIsNotAuthenticated_thenPresentLogin() {
        // given
        authService.isAuthenticated = false
        
        // when
        coordinator.start()
        
        // then
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is PhoneNumberViewController)
    }
    
    func test_whenUserCompleteLogin_thenShowTabBar() {
        // when
        NotificationCenter.default.post(.didLoginSuccessfully)
        
        // then
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is TabBarController)
    }
    
    func test_whenUserCompleteLogout_thenShowlogin() {
        // when
        NotificationCenter.default.post(.didLogout)
        
        // then
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is PhoneNumberViewController)
    }
    
    
    
    
    
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
