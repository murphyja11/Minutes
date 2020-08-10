//
//  UserViewModel.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-18.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import Foundation

struct UserViewModel {
    var email: String = ""
    var password: String = ""
    var fullname: String = ""
    var confirmPassword: String = ""
    
    // MARK: - Validation Checks
    
    func passwordsMatch() -> Bool {
        if self.password != "" && self.confirmPassword != "" {
             return confirmPassword == password
        }
        return false
    }
    
    func isEmpty(_field:String) -> Bool {
        return _field.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func isEmailValid () -> Bool {
        // Password must be 8 chars, contain a capital letter and a number
        let emailTest = NSPredicate(format: "SELF MATCHES %@",
                                       "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailTest.evaluate(with: self.email)
    }
    
    
    func isPasswordValid() -> Bool {
        // Password must be 8 chars, contain a capital letter and a number
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$")
        return passwordTest.evaluate(with: self.password)
    }
    
    var isSignInComplete:Bool  {
        if  !isEmailValid() ||
            isEmpty(_field: fullname) ||
            !isPasswordValid()
            || !passwordsMatch(){ return false }
        return true
    }
    
    var isLogInComplete:Bool {
        if isEmpty(_field: email) ||
            isEmpty(_field: password) {
            return false
        }
        return true
    }
    
    // MARK: - Validation Error Strings
    var validNameText: String {
        return "What's your name?"
        /*if !isEmpty(_field: fullname) {
            return ""
        } else {
            return "What's your name?"
        }*/
    }
    
    
    var validEmailAddressText:String {
        return "What's your email address"
        /*if isEmailValid() {
            return ""
        } else {
            return "What's your email address"
        }*/
    }
    
    var validPasswordText:String {
        return "Enter a password"
        /*if isPasswordValid() {
            return ""
        } else {
            return "Enter a password"
        }*/
    }
    
    var validPasswordTextPrompt:String {
        return "It must be 8 characters containing at least one number and one capital letter"
        /*if isPasswordValid() {
            return ""
        } else {
            return "It must be 8 characters containing at least one number and one capital letter"
        }*/
    }
    
    var validConfirmPasswordText: String {
        if passwordsMatch() {
            return ""
        } else {
            return "Almost.  Your passwords don't match."
        }
    }
}