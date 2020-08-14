//
//  SettingsView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/14/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userInfo: UserInfo
    
    @Binding var showThisView: Bool
    
    @State var errorString: String?
    @State var showAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button(action: {
                        FBAuth.logout { result in
                            switch result {
                            case .failure(let error):
                                print(error.localizedDescription)
                            case .success( _):
                                print("Logged out using log out button")
                            }
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Log out")
                                .font(.system(size: 20))
                                .foregroundColor(Color(red: 1, green: 0, blue: 0.5))
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarItems(leading: Text("Settings").font(.system(size: 20)).fontWeight(.bold), trailing: Button(action: { self.showThisView = false }) { Text("Done").font(.system(size: 20)) })
        }
        .alert(isPresented: self.$showAlert) {
            Alert(title: Text("Retrieval Error"), message: Text(self.errorString ?? ""), dismissButton: .default(Text("Ok")))
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
}
