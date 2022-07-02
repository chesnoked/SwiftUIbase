//
//  ContentView.swift
//  DreamApp
//
//  Created by Evgeniy Safin on 18.05.2022.
//

import SwiftUI


struct ContentView: View {

    @State private var checkAmount = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 0

    let tipPercentages = [0, 5, 10, 15, 20]

    var totalPerPerson: Double {

        let peopleCount = Double(numberOfPeople + 2) //Выбрали сколько человек
        let tipSelection = Double(tipPercentages[tipPercentage]) //Выбрали опцию сколько процентов
        let orderAmount = Double(checkAmount) ?? 0 //Опционально, если пользователь ввёл буквы, то возвращаем ноль
        let tipValue = orderAmount / 100 * tipSelection //Общие чаевые
        let grandTotal = orderAmount + tipValue //Стоимость заказа + чаевые
        let amountPerPerson = grandTotal / peopleCount//Чаевые, которые должен заплалить один человек

        return amountPerPerson

    }

    var body: some View {

        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                Section(header: Text("Сколько чаевых вы хотите оставить?")) {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0..<tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    } .pickerStyle(SegmentedPickerStyle())
                }
                Section {
                    Text("\(totalPerPerson , specifier: "%.2f")")
                }
            }
            .navigationBarTitle("Калькулятор чаевых", displayMode: .inline)
        }

    }


}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
