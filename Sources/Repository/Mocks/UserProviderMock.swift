//
//  UserProviderMock.swift
//  Providers
//
//  Created by Omar Alshammari on 19/10/1441 AH.
//

import Foundation
import Domain
import Application
//import Hydra

public class UserRepositoryMock: UserRepository {
    
    
    public init() {}

    private var users = [
        User(fullname: "Omar Alshammari",
             username: "omar_123456",
             phoneNumber: 966542652273,
             isVerified: true,
             password: nil),
        User(fullname: "Bander Alshammari",
             username: "bannder_123456",
             phoneNumber: 966542652274,
             isVerified: true,
             password: "p@ssw0rd")

    ]
    
    public func allUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        completion(.success(self.users))
    }
    
    public func save(user: User, completion: @escaping (Result<User, Error>) -> Void) {
        self.users.append(user)
        completion(.success(user))
    }
    
    public func findUser(by phoneNumber: Int64, completion: @escaping (Result<User, Error>) -> Void) {
        self.users.forEach { user in
            if user.phoneNumber == phoneNumber {
                completion(.success(user))
                return
            }
        }
        completion(.failure(RepositoryError.notFound))
    }
    
    public func saveUserPassword(phoneNumber: Int64,
                                 password: String,
                                 completion: @escaping (Result<Void, Error>) -> Void) {
        var found = false
        var error: Error = RepositoryError.notFound
        self.users.enumerated().forEach { index, user in
            if user.phoneNumber == phoneNumber {
                guard user.password == nil else {
                    error = RepositoryError.userAlreadyHasPassword
                    return
                }
                self.users.remove(at: index)
                let newUser = User(fullname: user.fullname, username: user.username, phoneNumber: user.phoneNumber, isVerified: user.isVerified, password: user.password)
                self.users.append(newUser)
                found = true
                return
            }
        }
        if found {
            completion(.success(()))
        } else {
            completion(.failure(error))
        }
    }
}
