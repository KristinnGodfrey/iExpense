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
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""

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
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
