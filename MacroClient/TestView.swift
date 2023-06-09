//
//  TestView.swift
//  iOSwebtest
//
//  Created by Giuseppe Rocco on 25/04/23.
//

import SwiftUI

struct TestView: View {
    @StateObject var tempData: TempData
    @State var refreshDone: Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                
                if !refreshDone {
                    CustomProgress(withText: true)
                    
                } else if tempData.requests.count < 1 {
                    GameSelection(tempData: tempData)
                    
                } else {
                    Dashboard(deviceProxy: proxy, tempData: tempData)
                        .navigationBarTitleDisplayMode(.large)
                        .navigationTitle("Requests")
                        .refreshable { _ = await tempData.fetchUserRequests() }
                }
            }
        }
        .task {
            // This needs to go once the App is build
            await tempData.fetchRemoteGames()
            
            refreshDone = await tempData.fetchUserRequests()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView(tempData: TempData())
    }
}
