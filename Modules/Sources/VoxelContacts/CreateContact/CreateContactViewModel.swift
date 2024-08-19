import Foundation
import Swinject
import PhoneNumberKit

public class CreateContactViewModel {
    private let container: Container
    private let coordinator: CreateContactCoordinator
    private let phoneNumberKit = PhoneNumberKit()
    private var repository: ContactsRepository {
        container.resolve(ContactsRepository.self)!
    }

    let mode: CreateContactMode
    var fullName: String = ""
    var phoneNumber: String = ""
    
    var isContactValid: Bool {
        isFullNameValid && isPhoneNumberValid
    }
    
    var isFullNameValid: Bool {
        fullName.trimmingCharacters(in: .whitespacesAndNewlines).count > 1
    }

    var isPhoneNumberValid: Bool {
        do {
            _ = try phoneNumberKit.parse(phoneNumber)
            return true

        } catch {
            return false
        }
    }

    init(container: Container, coordinator: CreateContactCoordinator, mode: CreateContactMode) {
        self.container = container
        self.coordinator = coordinator
        self.mode = mode
    }

    func createTapped() async throws {
        switch mode {
        case .create:
            try await createContact()
        case .edit(let contact):
            try await updateContact(contact)
        }
    }

    private func createContact() async throws {
        // Here you would typically use a service to create a new contact
//        let newContact = Contact(name: fullName, image: nil, isOnline: false, firstLetter: fullName.first ?? "A", phoneNumber: phoneNumber)
        // Save the new contact (this would depend on your app's architecture)
        // For example:
        // contactService.saveContact(newContact)
        
        let formattedPhoneNumber = try getFormattedPhoneNumber()
        
        try await repository.addContact(
            withPhoneNumber: formattedPhoneNumber,
            fullName: fullName
        )
                
        await MainActor.run {
            coordinator.dismiss()
        }
    }
    
    private func getFormattedPhoneNumber() throws -> String {
        let phoneNumber = try phoneNumberKit.parse(phoneNumber)
        return phoneNumberKit.format(phoneNumber, toType: .e164)
    }

    private func updateContact(_ contact: Contact) async throws {
        // Here you would typically use a service to update the existing contact
//        let updatedContact = Contact(name: fullName, image: contact.image, isOnline: contact.isOnline, firstLetter: fullName.first ?? "A", phoneNumber: phoneNumber)
        // Update the contact (this would depend on your app's architecture)
        // For example:
        // contactService.updateContact(updatedContact)
        
        await MainActor.run {
            coordinator.dismiss()
        }
    }
}
