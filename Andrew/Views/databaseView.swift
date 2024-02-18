//
//  databaseView.swift
//  Andrew
//
//  Created by Andrew Huang on 2/17/24.
//

import SwiftUI

struct databaseView: View {
    @ObservedObject var dataModel = DataBase.shared
    
    @State private var searchText: String = ""
    @State private var addButtonPressed : Bool = false
    private var keyValuePairs: [String] {
        searchText.components(separatedBy: " ")
    }
    
    var professors: [DukePerson] {
            
        dataModel.entries().filter { person in
            let firstName = keyValuePairs.indices.contains(0) ? keyValuePairs[0].lowercased() : ""
            let lastName = keyValuePairs.indices.contains(1) ? keyValuePairs[1].lowercased() : ""
            return person.role == .Professor && (firstName != "" ? person.fName.lowercased().hasPrefix(firstName) : true) && (lastName != "" ? person.lName.lowercased().hasPrefix(lastName) : true)
        }
    }
    var TAs: [DukePerson]{
        dataModel.entries().filter { person in
            let firstName = keyValuePairs.indices.contains(0) ? keyValuePairs[0].lowercased() : ""
            let lastName = keyValuePairs.indices.contains(1) ? keyValuePairs[1].lowercased() : ""
            return person.role == .TA && (firstName != "" ? person.fName.lowercased().hasPrefix(firstName) : true) && (lastName != "" ? person.lName.lowercased().hasPrefix(lastName) : true)
        }
    }
    var students: [DukePerson]{
        dataModel.entries().filter { person in
            let firstName = keyValuePairs.indices.contains(0) ? keyValuePairs[0].lowercased() : ""
            let lastName = keyValuePairs.indices.contains(1) ? keyValuePairs[1].lowercased() : ""
            return person.role == .Student && (firstName != "" ? person.fName.lowercased().hasPrefix(firstName) : true) && (lastName != "" ? person.lName.lowercased().hasPrefix(lastName) : true)
        }
    }
    var others: [DukePerson]{
        dataModel.entries().filter { person in
            let firstName = keyValuePairs.indices.contains(0) ? keyValuePairs[0].lowercased() : ""
            let lastName = keyValuePairs.indices.contains(1) ? keyValuePairs[1].lowercased() : ""
            return person.role == .Other && (firstName != "" ? person.fName.lowercased().hasPrefix(firstName) : true) && (lastName != "" ? person.lName.lowercased().hasPrefix(lastName) : true)
        }
    }
    
    var body: some View {
        List {
            Section(header: Text("Professors").bold() .font(.subheadline)) {
                ForEach(professors, id: \.DUID) { person in
                    NavigationLink(destination: dukepersonView(person: person)) {
                        rowView(person:person)
                    }
                }
            }
            Section(header: Text("TAs").bold() .font(.subheadline)) {
                ForEach(TAs, id: \.DUID) { person in
                    NavigationLink(destination: dukepersonView(person: person)) {
                        rowView(person:person)
                    }
                }
            }
            Section(header: Text("Students").bold() .font(.subheadline)) {
                ForEach(students, id: \.DUID) { person in
                    NavigationLink(destination: dukepersonView(person: person)) {
                        rowView(person:person)
                    }
                }
            }
            Section(header: Text("Other").bold() .font(.subheadline)) {
                ForEach(others, id: \.DUID) { person in
                    NavigationLink(destination: dukepersonView(person: person)) {
                        rowView(person:person)
                    }
                }
            }
        }
        .navigationTitle("Duke Database")
        .searchable(text: $searchText, prompt: "Search for a Person...") {}
        .navigationBarItems(trailing: NavigationLink(destination: editDatabaseView(dataModel: dataModel)){
            Image(systemName: "plus")
                .font(.title)
        })
        
    }
}

struct rowView: View {
    let person: DukePerson
    let height: Double = 90.0
    let width: Double = 90.0
    var body: some View {
        HStack {
            profilePic(imageString: person.picture, height: height, width: width)
            VStack(alignment: .leading) {
                Text("\(person.fName) \(person.lName)")
                    .font(.system(size: 20))
                    .bold()
                    .underline()
                Text("DUID: \(String(person.DUID))")
                    .font(.system(size: 12))
                    .italic()
                Text("Email: \(person.netID)@duke.edu")
                    .font(.system(size: 12))
                    .italic()
                Text("Program: \(person.program.rawValue)")
                    .font(.system(size: 12))
                    .italic()
                Text("Plan: \(person.plan.rawValue)")
                    .font(.system(size: 12))
                    .italic()
                Text("netID: \(person.netID)")
                    .font(.system(size: 12))
                    .italic()
            }
        }
    }
}
/*
 #Preview {
 databaseView()
 }
 */
