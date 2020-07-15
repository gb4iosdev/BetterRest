//
//  ContentView.swift
//  BetterRest
//
//  Created by Gavin Butler on 12-07-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")
                .font(.headline)) {
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                Section(header: Text("Desired amount of sleep:")
                .font(.headline)) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                    //.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 80))
                }
                Section(header: Text("Daily coffee intake:")
                .font(.headline)) {
                    Picker("Daily Coffee Intake", selection: $coffeeAmount) {
                        ForEach(1..<21) {
                            Text("\($0) \($0 == 1 ? "Cup" : "Cups")")
                        }
                    }
                .labelsHidden()
                }
                Section(header: Text("Your ideal bedtime is")
                    .font(.headline)) {
                    Text("\(sleepingTimeMessage)")
                }
            }
            .navigationBarTitle("Better Rest")
//            .navigationBarItems(trailing:
//                Button(action: calculateBedTime) {
//                    Text("Calculate")
//                }
//            )
//                .alert(isPresented: $showingAlert) {
//                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//            }
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    private var sleepingTimeMessage: String {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount+1))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short

            return "\(formatter.string(from: sleepTime))"
        } catch {
            return "Error:  Sorry, there was a problem calculating your bedtime."
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//Alert:
/*
 .alert(isPresented: $showingAlert) {
 Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
*/


//Stepper:
/*
Stepper(value: $coffeeAmount, in: 1...20) {
    if coffeeAmount == 1 {
        Text("1 cup")
    } else {
        Text("\(coffeeAmount) cups")
    }
}
.padding(EdgeInsets(top: 0, leading: 80, bottom: 0, trailing: 80))
 */

//Date Formatter
/*
         let formatter = DateFormatter()
         formatter.timeStyle = .short
         let dateString = formatter.string(from: Date())
 */

//Using components(3):
/*
        let components = Calendar.current.dateComponents([.hour, .minute], from: someDate)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
 */


//Using components(2):
/*var components = DateComponents()
        components.hour = 8
        components.minute = 0
        let date = Calendar.current.date(from: components) ?? Date()
 */

//Using Date Components:
/*
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        let date = Calendar.current.date(from: components) ?? Date()
*/

//Dates as ranges
/*
        let now = Date()
        let tomorrow = now.addingTimeInterval(86_400)
        let range = now ... tomorrow
}*/

//DatePicker
/*struct ContentView: View {
    @State private var wakeUp = Date()
    var body: some View {
        DatePicker("Please enter a date", selection: $wakeUp, in: Date()...)    //Can also used displayedComponents parameter to control what date elements are displayed
        .labelsHidden()
    }
}*/


//Steppers:
/*struct ContentView: View {
    @State private var sleepAmount = 8.0
    var body: some View {
        Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
            Text("Sleep Amount: \(sleepAmount, specifier: "%g") hours")
        }
    }
}*/
