//
//  ContentView.swift
//  calc4
//
//  Created by Andrei Nosov on 03.12.2021.
//

import SwiftUI
import Foundation




enum CalcButtons: String {
    case zero, one, two, three, four, five, six, seven, eight, nine
    case equals, plus, minus, multiply, divide
    case ac, plusMinus, percent, decimal
    
    
    
    
    var buttonName: String{
        switch self {
        case .zero: return "0"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .equals: return "="
        case .plus: return "+"
        case .minus: return "-"
        case .divide: return "/"
        case .plusMinus: return "+/"
        case .percent: return "%"
        case .decimal: return "."
        case .multiply: return "x"
        default: return "AC"
        }
    }
    var backgroundColor: Color {
        switch self {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .decimal:
            return Color(.darkGray)
        case .equals, .plus, .minus, .multiply, .divide:
            return Color(.orange)
        default: return .gray
        }
        
        
    }
    
}






class GlobalEnvironment: ObservableObject {
    @Published var display = ""
    @Published var recordedValue1 = ""
    @Published var currentOperation = ""
    
    
    
    func didTap(button: CalcButtons) {
        switch button {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            
            display += button.buttonName
            
        case .equals:
            let first = Double(recordedValue1)!
            let second = Double(display)!
            
            if currentOperation == "+" {
                display = "\(first + second)"
            } else if currentOperation == "-" {
                display = "\(first - second)"
            } else if currentOperation == "/" {
                display = "\(first / second)"
            } else if currentOperation == "x" {
                display = "\(first * second)"
            }
        case .plus, .minus, .multiply, .divide:
            recordedValue1 = display
            currentOperation = button.buttonName
            display = ""
        case .ac:
            display = ""
        case .plusMinus:
            let calc = Double(display)
            display = "\(-calc!)"
        case .percent:
            guard display != "" else {break}
            let calc  = Double(display)! / 100
            display = "\(calc)"
            recordedValue1 = display
            
        case .decimal:
            guard !display.contains(button.buttonName) else{
                break
            }
            display += button.buttonName
        }
    }
    
}







struct ContentView: View {
    
    @EnvironmentObject var env: GlobalEnvironment
    
    let buttons: [[CalcButtons]] = [
        [.ac, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .decimal, .equals]
    ]
    
    
    var body: some View {
        ZStack(alignment: .bottom){
            Color.black
            
            VStack{
                HStack{
                    Spacer()
                    Text(env.display).font(.system(size: 64))
                    
                }.padding()
                
                VStack{
                    ForEach(buttons, id:\.self) {raw in
                        HStack(spacing: 15){
                            ForEach(raw, id: \.self) {
                                button in
                                
                                CalcButtonView(button: button)
                                
                            }
                        }
                    }
                }
            }.padding()
            
            
            
        }.edgesIgnoringSafeArea(.bottom)
            .foregroundColor(.white)
    }
    
    
    
    
    
    
    
}

struct CalcButtonView: View {
    
    var button: CalcButtons
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View {
        Button(action: {
            
            self.env.didTap(button: button)
            
            
        }, label: {
            Text(button.buttonName)
                .font(.system(size: 32))
                .frame(width: self.buttonWidth(button: button),
                       height: (UIScreen.main.bounds.width - 5 * 12) / 4)
                .background(button.backgroundColor)
                .cornerRadius(self.buttonWidth(button: button))
        })
    }
    
    func buttonWidth(button: CalcButtons)-> CGFloat {
        if button == .zero {
            return (UIScreen.main.bounds.width - 4 * 12) / 2
        }
        
        
        return (UIScreen.main.bounds.width - 5 * 12) / 4
        //5 расстояний между кнопками * на их размер (спейсинг hstack) отнимаем от ширины поля общее расстояние между кнопками,  и оставшееся место под кнопки делим на 4 кнопки
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnvironment())
            .previewInterfaceOrientation(.portrait)
    }
}
