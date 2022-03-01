//
//  ChatsView.swift
//  ClassmateConnector
//
//  Created by Fletcher Wells on 2/26/22.
//

import SwiftUI

struct ChatsView: View {
    @Binding var courses: [Course]
    @State var chats: [Chat] = [Chat(name: "Jai Chawla"), Chat(name: "Allen Su")]
    
    var body: some View {
        List {
            ForEach (self.chats) { chat in
                NavigationLink(destination: ChatView(chat: chat), label: {
                    Text(chat.name)
                }).padding()
            }
        }.navigationTitle("Study Buddies")
    }
}

/*
struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView(courses: [])
    }
}
*/
