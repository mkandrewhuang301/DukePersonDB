//
//  dukepersonView.swift
//  Andrew
//
//  Created by Andrew Huang on 2/17/24.
//

import SwiftUI

struct dukepersonView: View {
    let person: DukePerson
    let height: Double = 210.0
    let width: Double = 210.0
    var body: some View {
        
        VStack{
            Image("duke")
                .frame(width :400, height:340)
                .clipped()
            profilePic(imageString: person.picture, height: height, width: width)
                
                .offset(y:-170)
                .padding(.bottom, -130)
            
            Text(person.description)
                .frame(width: 300)
                .font(.custom("Times New Roman", size: 18))
            Spacer()
        }
        .background(Color(red: 0.94, green: 0.94, blue: 0.92))
        
    }
}
/*
 #Preview {
 dukepersonView()
 }
 */
