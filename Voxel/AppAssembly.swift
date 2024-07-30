import Foundation
import Swinject
import VoxelAuthentication
import VoxelLogin
import VoxelSettings

class AppAssembly {
    
    let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    func assemble() {
        let authService = AuthServiceLive()
        let userRepository = UserProfileRepositoryLive(authService: authService)
            
        let profilePictureRepository = ProfilePictureRepositoryLive(
            authService: authService,
            userProfileRepository: userRepository
        )
        
        container.register(AuthService.self) { container in
            authService
        }
        
        container.register(UserProfileRepository.self) { container in
            userRepository
        }
        
        container.register(ProfilePictureRepository.self) { container in
            profilePictureRepository
        }
        
//        let authServiceFromContainer = container.resolve(authService.self)!
    }
}

/*
class DIContainer: VoxelSettingsDependencies, VoxelLoginDependencies {
    let authService: AuthService
    let userRepository: UserProfileRepository
    let profilePictureRepository: ProfilePictureRepository
    
    init() {
        let authService = AuthServiceLive()
        let userRepository = UserProfileRepositoryLive(authService: authService)
            
        let profilePictureRepository = ProfilePictureRepositoryLive(
            authService: authService,
            userProfileRepository: userRepository
        )
        
        self.authService = authService
        self.userRepository = userRepository
        self.profilePictureRepository = profilePictureRepository
    }
}
*/
