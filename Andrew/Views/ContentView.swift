//
//  ContentView.swift
//  Andrew
//
//  Created by Andrew Huang on 2/17/24.
//

import SwiftUI
/*
 Should contain button download/replace, download/update.
 On load, should bootstrap your profile
 @StateObject private var dataModel = DataBase.shared
*/
class DownloadManager: NSObject, ObservableObject, URLSessionDownloadDelegate {
    @Published var resultText: String = ""
    @Published var progressBarValue: Float = 0.0
    
    //var dataModel = DataBase.shared
    
    var downloadingCompletionHandler: (([DukePerson]) -> Bool)?
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            //print(progress)
            self.progressBarValue = progress
            /*
            DispatchQueue.main.async {
                self.ProgressBar.setProgress(progress, animated: true)
            }
             */
   }
   func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
           //print("amdownloaing")
           if let error = error {
               print("Download failed with error: \(error.localizedDescription)")
           } else {
               print("Download task completed successfully.")
               self.progressBarValue = 0
           }
   }
   func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
       print("Download completed. File saved at: \(location.absoluteString)")
       do {
           let data = try Data(contentsOf: location)
           do{
               let decoder = JSONDecoder()
               if let decoded = try? decoder.decode([DukePerson].self, from: data) {
                   if downloadingCompletionHandler!(decoded){
                       self.resultText = "Successfully downloaded from server."
                       //let _ = dataModel.save()
                   }
               }
               else{
                   self.resultText = "Problem parsing some data. Errors in Server."
               }
               }
       }
       catch{
           print("Error retrieving downloaded data.")
       }
   }
    func downloadData(completionHandler: (([DukePerson]) -> Bool)?){
        self.downloadingCompletionHandler = completionHandler
        let url = "http://ece564.rc.duke.edu:8080/entries/all"
        let authentication = "5cb24aa7e0551f28395c993a3500cb6ada1f25eaff535f1b23e507ffc8503694"
        self.resultText = "Downloading Data..."
        _ = download(website: url, auth: authentication, delegate: self )
        
        
    }
    func download(website: String, auth: String, delegate: URLSessionDelegate?) -> Bool{
        ///set up URLSession to connect to website
        guard let url  = URL(string: website)else{
            return false
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        //set up credentials
        let credentials =  "ah629:\(auth)"
        guard let authData = credentials.data(using: .utf8) else{
            return false
        }
        let base64Auth = authData.base64EncodedString()
        request.addValue("Basic \(base64Auth)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //download from website
        let session: URLSession
        if let delegate = delegate{ // if not nil
            let config = URLSessionConfiguration.default
            session = URLSession(configuration: config, delegate: delegate, delegateQueue: .main)
        }else{
            session  = URLSession.shared
        }
        let task = session.downloadTask(with: request)
        task.resume()
        return true
    }
    
}
struct ContentView: View {
    @StateObject private var dataModel = DataBase.shared
    @StateObject private var downloadManager = DownloadManager()
    @State private var progressBarValue: Float = 0.0
    @State private var resultText: String = ""
    
    @State private var isNextViewActive = false
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Download/Replace"){
                    downloadManager.downloadData(completionHandler: dataModel.replaceDB)
                }
                .padding()
                Button("Download/Update"){
                    downloadManager.downloadData(completionHandler: dataModel.updateDB)
                }
                .padding()
                ProgressBar(value: $downloadManager.progressBarValue)
                .padding()
                Text(downloadManager.resultText)
                .padding()
                NavigationLink(destination: databaseView()) {
                    Text("Continue")
                }
                
            }
            .onAppear(){
                if !dataModel.load(DataBase.sandboxPath){
                    let me: DukePerson = DukePerson(DUID: 1227613, netID:"ah629", fName:"Andrew", lName: "Huang", from: "Cary, NC", hobby: "piano", languages:["C++, Python"], moviegenre: "zombie", gender: Gender.Male, role: Role.Student, program: Program.BS, plan: Plan.CS, picture: mepicString, team: "McDonalds")
                    let _ = dataModel.add(me)
                    let _ = dataModel.save()
                }
                let me: DukePerson = DukePerson(DUID: 1227613, netID:"ah629", fName:"Andrew", lName: "Huang", from: "Cary, NC", hobby: "piano", languages:["C++, Python"], moviegenre: "zombie", gender: Gender.Male, role: Role.Student, program: Program.BS, plan: Plan.CS, picture: mepicString, team: "McDonalds")
                let _ = dataModel.update(me)
                print("Andrew Added")
                let _ = dataModel.save()
            }
        }
    }
}
struct ProgressBar: View {
    @Binding var value: Float

    var body: some View {
        ProgressView(value: value)
            .frame(width: 200)
    }
}


#Preview {
    ContentView()
}
