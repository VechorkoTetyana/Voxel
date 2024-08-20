import Foundation
import VoxelSettings

public struct Contact {
    public let uid: String
    public let name: String
    public var phoneNumber: String {
        userProfile.phoneNumber
    }
    public let userProfile: UserProfile
    public let isMutual: Bool

/*    public let image: UIImage?
    public let isOnline: Bool
    public let firstLetter: String
    public let phoneNumber: String  */
    
    init(uid: String, name: String, userProfile: UserProfile, isMutual: Bool) {
        self.uid = uid
        self.name = name
        self.userProfile = userProfile
        self.isMutual = isMutual
    }
}

public extension Contact {
    var profilePictureUrl: URL? {
        isMutual ? userProfile.profilePictureUrl : nil
    }
}
