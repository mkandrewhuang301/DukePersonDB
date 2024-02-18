//
//  profilePic.swift
//  Andrew
//
//  Created by Andrew Huang on 2/17/24.
//

import SwiftUI

struct profilePic: View {
    let imageString: String
    let height: Double
    let width: Double
    var body: some View {
        if let imageData = Data(base64Encoded: imageString), let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.gray, lineWidth:4)
                }
                .shadow(radius: 10)
                .frame(width: width, height: height)
            } else {
                Image("avatar")
                    .resizable()
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(.gray, lineWidth:4)
                    }
                    .shadow(radius: 10)
                    .frame(width: width, height: height)
            }
    }
}
/*
 #Preview {
     profilePic(imageString: mepicString, height: 100.0, width: 100.0)
 }
 */
  
