//
//  ContentView.swift
//  iExpense
//
//  Created by Kristinn Godfrey on 05/09/2020.
//  Copyright © 2020 me.kristinn.godfrey. All rights reserved.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
}

struct Title: ViewModifier {
    var num: Int
    
    func body(content: Content) -> some View {
        if num < 10 {
            return content.foregroundColor(.green)
        }
        else if num < 50 {
            return content.foregroundColor(.yellow)
        }
        else if num > 100 {
            return content.foregroundColor(.red)
        }
        else {
            return content.foregroundColor(.black)
        }
    }
}

class Expenses: ObservableObject {
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }

        self.items = []
    }
    @Published var items: [ExpenseItem] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    var body: some View{
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }

                        Spacer()
                        Text("$\(item.amount)").modifier(Title(num: item.amount))
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(trailing:
                HStack {
                    EditButton().padding(20)
                    Button(action: {
                        self.showingAddExpense = true
                    }) {
                        Text("Add entry")
                    }
                }
            )

        }.sheet(isPresented: $showingAddExpense) {
            AddView(expenses: self.expenses)
        }
    }
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
