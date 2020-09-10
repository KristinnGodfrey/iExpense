//
//  SwiftUIView.swift
//  iExpense
//
//  Created by Kristinn Godfrey on 09/09/2020.
//  Copyright © 2020 me.kristinn.godfrey. All rights reserved.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var expenses: Expenses
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var isAlert = false
    @State private var messageForAlert = ""

    

    static let types = ["Business", "Personal"]

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing:
                Button("Save") {
                   
                if let actualAmount = Int(self.amount) {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                }
                else {
                    self.isAlert = true 
                    self.messageForAlert = self.amount
                    }
            }).alert(isPresented: $isAlert) {
                Alert(title: Text("Invalid input"), message: Text("You can't enter \(self.messageForAlert)"), dismissButton: .default(Text("Continue")) {
                })
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
