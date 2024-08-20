import UIKit
import VoxelSettings
import FirebaseDatabase
import VoxelAuthentication
import Swinject

public struct Contact {
    public let uid: String
    public let name: String
    public var phoneNumber: String {
        userProfile.phoneNumber
    }
    public let userProfile: UserProfile
    
/*    public let image: UIImage?
    public let isOnline: Bool
    public let firstLetter: String
    public let phoneNumber: String  */
    
    public init(uid: String, name: String, userProfile: UserProfile) {
        self.uid = uid
        self.name = name
        self.userProfile = userProfile
    }
}

public protocol ContactsRepository {
    func fetch() async throws -> [Contact]
    func addContact(withPhoneNumber phoneNumber: String, fullName: String) async throws
    func updateContact(_ contact: Contact, with fullName: String) async throws
    func fetchContact(with uid: String) async throws -> Contact
}

enum ContactsRepositoryError: Error {
    case contactNotRegistered
}

public struct ContactRelationship: Decodable {
    let name: String
}

public class ContactsRepositoryLive: ContactsRepository {
    
    private let reference: DatabaseReference
    private let phoneNumberReference: DatabaseReference
    private let usersReference: DatabaseReference
    private let container: Container
    private var authService: AuthService {
        container.resolve(AuthService.self)!
    }

    public init(container: Container) {
        self.container = container
        reference = Database.database().reference().child("contacts")
        phoneNumberReference = Database.database().reference().child(DatabaseBranch.phoneNumbers.rawValue)
        usersReference = Database.database().reference().child("users")
    }
    
    public func fetch() async throws -> [Contact] {
        guard let user = authService.user else {
            throw AuthError.notAuthenticated
        }
        
        let snapshot = try await reference.child(user.uid).getData()
        let contacts = try snapshot.data(as: [String: ContactRelationship].self)
        
        
        var contactsArray = [Contact]()
        
        // fetch contacts one after another, it´s slow. It coud be done parallely
        for(contactUid, contactRel) in contacts {
            let profile = try await fetchProfile(with: contactUid)
            let contact = Contact(
                uid: contactUid,
                name: contactRel.name,
                userProfile: profile
            )
            contactsArray.append(contact)
        }
        return contactsArray
    }
    
    private func fetchProfile(with uid: String) async throws -> UserProfile {
        let snapshot = try await usersReference.child(uid).getData()
        return try snapshot.data(as: UserProfile.self)
    }
    
    public func fetchContact(with uid: String) async throws -> Contact {
        guard let user = authService.user else {
            throw AuthError.notAuthenticated
        }
        
        let profile = try await fetchProfile(with: uid)
        let snapshot = try await reference.child(user.uid).child(uid).getData()
        let contactRel = try snapshot.data(as: ContactRelationship.self)
        
        return Contact(uid: uid, name: contactRel.name, userProfile: profile)
    }
    
    public func addContact(withPhoneNumber phoneNumber: String, fullName: String) async throws {
        let snapshot = try await phoneNumberReference.child(phoneNumber).getData()
        
        guard let contactUserID = snapshot.value as? String else {
            throw ContactsRepositoryError.contactNotRegistered
        }
        
        guard let user = authService.user else {
            throw AuthError.notAuthenticated
        }

        try await reference.child(user.uid).child(contactUserID).setValue([
            "name": fullName
        ])
    }
    
    public func updateContact(_ contact: Contact, with fullName: String) async throws {
        guard let user = authService.user else {
            throw AuthError.notAuthenticated
        }
        try await reference.child(user.uid).child(contact.uid).child("name").setValue(fullName)
    }
}
