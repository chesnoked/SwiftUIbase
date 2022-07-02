//
//  ContentView.swift
//  MoneyFlowApp
//
//  Created by Evgeniy Safin on 26.05.2022.
//

import SwiftUI



//Структура представляющая одну затрату
struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String//Имя транзакции
    let type: String//Категория
    let amount: Int//Сумма
}

//Массив класс который будет хранить все затраты в одной переменной
class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
    }
}



struct ContentView: View {
    
    @State private var showingAddExpense = false
    @ObservedObject var expenses = Expenses()//Просим наблюдать за expenses и когда items меняется то всё View будет обновляться
    
    var body: some View {
        
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
                        Text("₽\(item.amount)")
                    }
                }
                .onDelete(perform: removeItems)
                
            }
            .navigationBarTitle("Мои расходы")
            .navigationBarItems(trailing:
                                    Button(action: {
                self.showingAddExpense = true
            }) {
                Image(systemName: "plus")
            }
            )
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: self.expenses)
            }
        }
        
    }
    func removeItems(as offsets: IndexSet)
    {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
