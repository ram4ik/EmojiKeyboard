//
//  ContentView.swift
//  EmojiKeyboard
//
//  Created by ramil on 26.02.2020.
//  Copyright © 2020 com.ri. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var txt = ""
    @State private var show = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { _ in
                VStack {
                     HStack(spacing: 15) {
                         TextField("Message", text: self.$txt)
                         
                         Button(action: {
                            UIApplication.shared.windows.first?.rootViewController?.view.endEditing(true)
                            self.show.toggle()
                         }) {
                             Image(systemName: "smiley")
                                 .foregroundColor(Color.black.opacity(0.5))
                         }
                     }.padding(12)
                     .background(Color.white)
                     .clipShape(Capsule())
                }.padding()
                
            }
            EmojiView(show: self.$show, txt: self.$txt)
                .offset(y: self.show ? (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! : UIScreen.main.bounds.height)
        }.background(Color("Color"))
        .edgesIgnoringSafeArea(.all)
        .animation(.default)
            .onAppear() {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { (_) in
                    self.show = false
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct EmojiView: View {
    @Binding var show: Bool
    @Binding var txt: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    ForEach(self.getEmojiList(), id: \.self) { i in
                        HStack(spacing: 25) {
                            ForEach(i, id: \.self) { j in
                                Button(action: {
                                    self.txt += String(UnicodeScalar(j)!)
                                }) {
                                    if (UnicodeScalar(j)?.properties.isEmoji)! {
                                        Text(String(UnicodeScalar(j)!))
                                            .font(.system(size: 55))
                                    } else {
                                        Text("")
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .frame(width: UIScreen.main.bounds.width,
                   height: UIScreen.main.bounds.height / 3)
                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
            .background(Color.white)
            .cornerRadius(25)
            
            Button(action: {
                self.show.toggle()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
            }.padding()
        }
    }
    
    func getEmojiList() -> [[Int]] {
        var emojis: [[Int]] = []
        for i in stride(from: 0x1F601, to: 0x1F64F, by: 4) {
            var temp: [Int] = []
            for j in i...i*3 {
                temp.append(j)
            }
            emojis.append(temp)
        }
        return emojis
    }
}
