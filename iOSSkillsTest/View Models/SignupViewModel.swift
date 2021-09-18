//
//  SignupViewModel.swift
//  iOSSkillsTest
//
//  Created by Milos Otasevic on 18.9.21..
//

import SwiftUI
import Combine


class SignupViewModel: ObservableObject{
    @Published var username = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    @Published var formIsValid = false
    @Published var usernameAvailable = true
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.formIsValid, on: self)
            .store(in: &cancellable)
    }
        
    //MARK: Vaidation Publishers
    
    private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
        $username
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map {
                if !$0.isEmpty {
                    NetworkService.shared.usernameAvailable($0) { response in
                        self.usernameAvailable = response
                    }
                }
                return !$0.isEmpty && self.usernameAvailable }
            .eraseToAnyPublisher()
        }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { $0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $repeatPassword)
            .map { $0 == $1}
            .eraseToAnyPublisher()
    }
    
    private var isPasswordStrongPublisher: AnyPublisher<Bool, Never>{
        $password
            .removeDuplicates()
            .map { $0.count > 7}
            .eraseToAnyPublisher()
    }
    
    private var passwordIsValidPublisher: AnyPublisher<Bool, Never>{
        Publishers.CombineLatest3(isPasswordEmptyPublisher, arePasswordsEqualPublisher, isPasswordStrongPublisher)
            .map { !$0 && $1 && $2 }
            .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never>{
        Publishers.CombineLatest(passwordIsValidPublisher,  isUsernameValidPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
}
