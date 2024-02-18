//
//  editDatabaseView.swift
//  Andrew
//
//  Created by Andrew Huang on 2/18/24.
//

import SwiftUI

struct editDatabaseView: View{
    @ObservedObject var dataModel: DataBase
    @State private var inputText: String = ""
    @State private var DUIDInput: String = ""
    @State private var result: String = ""
    var body: some View{
        Text("Modify Database Page")
            .bold()
            .font(.title)
            .underline()
            .padding()
        TextField("DUID", text: $DUIDInput)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("Enter information", text: $inputText)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
        Button("Add person"){
            addPerson(inputText: inputText, dataModel: dataModel, DUIDVal: DUIDInput, output: $result)
        }
        .padding()
        Button("Update Person"){
            updatePerson(inputText: inputText, dataModel: dataModel, DUIDVal: DUIDInput, output: $result)
        }
        .padding()
        Button("Delete Person"){
            delPerson(inputText: inputText, dataModel: dataModel, DUIDVal: DUIDInput, output: $result)
        }
            .padding()
        Button("Save"){
            save(dataModel: dataModel, output: $result)
        }
            .padding()
        Text(result)
        .padding()
        Spacer()
    }
 
    
    //dataModel is ok, dont need binding because i have observedobject
    func addPerson(inputText: String, dataModel: DataBase, DUIDVal: String, output: Binding<String>){
        
        var fName:String = "firstname"
        var lName:String = "lastname"
        var from: String = "unknown"
        var netID:String = "unknown"
        var hobby: String = "unknown"
        var languages: [String] = []
        var moviegenre: String = "unknown"
        var gender: Gender = .Unknown
        var role: Role = .Other
        var plan: Plan = .Other
        var program: Program = .Other
        var picture: String = ""
        var team: String = ""
        let keyValuePairs = inputText.components(separatedBy: ", ")
        for pair in keyValuePairs {
            let keyValue = pair.components(separatedBy: "=")
            if keyValue.count == 2 {
                let key = keyValue[0]
                let value = keyValue[1]
                switch key.lowercased() {
                case "fn":
                    fName = value
                case "ln":
                    lName = value
                case "fr":
                    from = value
                case "ge":
                    gender = mapGender(inp: value)
                case "ro":
                    role = mapRole(inp: value)
                case "ne":
                    netID = value
                case "ho":
                    hobby = value
                case "mo":
                    moviegenre = value
                case "la":
                    languages = value.components(separatedBy: ",")
                case "pl":
                    plan = mapPlan(inp:value)
                case "pr":
                    program = mapProgram(inp:value)
                case "pi":
                    picture = value
                case "te":
                    team = value
                default:
                    continue
                }
            }
        }
        //case for netID Note that having
        if DUIDVal.isEmpty{
            output.wrappedValue = "Enter a DUID for this person "
            return
        }
        if Int(DUIDVal) == nil{
            output.wrappedValue = "Enter a DUID with only numbers for this person"
            return
        }
        //assert that Int(DUIDVal) != nil
        let newPerson: DukePerson = DukePerson(DUID: Int(DUIDVal)!, netID: netID, fName: fName, lName: lName,from: from, hobby:hobby, languages: languages, moviegenre: moviegenre, gender: gender, role: role, program: program, plan:plan, picture: picture, team: team)
        let result: Bool = dataModel.add(newPerson)
        if result == true{
            output.wrappedValue = "Person added to database"
        }else{
            output.wrappedValue = "Failed. People with DUID already exists. Are you trying to update a the person with DUID instead?"
        }
    }
    func updatePerson(inputText: String, dataModel: DataBase, DUIDVal: String, output: Binding<String>){
        if DUIDVal.isEmpty{
            output.wrappedValue = "Enter a DUID for this person "
            return
        }
        if Int(DUIDVal) == nil{
            output.wrappedValue = "Enter a DUID with only numbers for this person"
            return
        }
        //assert that Int(DUIDVal) != nil
        var fName:String = "firstname"
        var lName:String = "lastname"
        var from: String = "unknown"
        var netID:String = "unknown"
        var hobby: String = "unknown"
        var languages: [String] = []
        var moviegenre: String = "unknown"
        var gender: Gender = .Unknown
        var role: Role = .Other
        var plan: Plan = .Other
        var program: Program = .Other
        var team: String = "unknown"
        var picture: String = ""
        let keyValuePairs = inputText.components(separatedBy: ", ")
        output.wrappedValue = "unknown key"
        for pair in keyValuePairs {
            let keyValue = pair.components(separatedBy: "=")
            if keyValue.count == 2 {
                let key = keyValue[0]
                let value = keyValue[1]
                switch key.lowercased() {
                case "fn":
                    fName = value
                case "ln":
                    lName = value
                case "fr":
                    from = value
                case "ge":
                    gender = mapGender(inp: value)
                case "ro":
                    role = mapRole(inp: value)
                case "ne":
                    netID = value
                case "ho":
                    hobby = value
                case "mo":
                    moviegenre = value
                case "la":
                    languages = value.components(separatedBy: ",")
                case "pl":
                    plan = mapPlan(inp:value)
                case "pr":
                    program = mapProgram(inp:value)
                case "te":
                    team = value
                default:
                    continue
                }
            }
        }
        //if person found in database
        if let oldperson: DukePerson = dataModel.find(Int(DUIDVal)!){
            if netID == "unknown"{
                netID = oldperson.netID
            }
            if fName == "firstname"{
                fName = oldperson.fName
            }
            if lName == "lastname"{
                lName = oldperson.lName
            }
            if from == "unknown"{
                from = oldperson.from
            }
            if hobby == "unknown"{
                hobby = oldperson.hobby
            }
            if languages.isEmpty == true{
                languages = oldperson.languages
            }
            if moviegenre == "unknown"{
                moviegenre = oldperson.moviegenre
            }
            if gender == .Unknown{
                gender = oldperson.gender
            }
            if role == .Other {
                role = oldperson.role
            }
            if program == .Other{
                program = oldperson.program
            }
            if plan == .Other{
                plan = oldperson.plan
            }
            if picture == ""{
                picture = oldperson.picture
            }
            let updatedPerson: DukePerson = DukePerson(DUID: Int(DUIDVal)!, netID: netID, fName: fName, lName: lName,from: from, hobby:hobby, languages: languages, moviegenre: moviegenre, gender: gender, role: role, program:program, plan:plan, picture: picture, team: team)
            let _: Bool = dataModel.update(updatedPerson)
            output.wrappedValue = "Person Updated"
            //assert that person with duid exists, just need to update
        }else{
            //assert: datamodel does not have entry for current DUID
            let newPerson: DukePerson = DukePerson(DUID: Int(DUIDVal)!, netID: netID, fName: fName, lName: lName,from: from, hobby:hobby, languages: languages, moviegenre: moviegenre, gender: gender, role: role, program: program, plan:plan, picture:picture, team: team)
            let _: Bool = dataModel.add(newPerson)
            output.wrappedValue = "No person with given DUID. Person added to database instead"
        }
    }
    func delPerson(inputText: String, dataModel: DataBase, DUIDVal: String, output: Binding<String>) {
        if DUIDVal.isEmpty{
            output.wrappedValue = "Person not Deleted. Enter DUID "
            return
        }
        if Int(DUIDVal) == nil{
            output.wrappedValue  = "Enter a DUID with only numbers for this person"
            return
        }
        //assert that Int(DUIDVal) != nil
        if dataModel.delete(Int(DUIDVal)!) == true{
            output.wrappedValue  = "Person deleted"
            return
        }
        else{
            output.wrappedValue  = "DUID does not match anyone in the database. Please try again "
            return
        }
    }
    func save( dataModel: DataBase, output: Binding<String>){
        let result = dataModel.save()
        if result == true{
            output.wrappedValue = "Saved Successfully"
        }
        else{
            output.wrappedValue = "Error Saving"
        }
    }
    func mapGender(inp: String)-> Gender{
        if(inp.isEmpty){
            return .Unknown
        }
        switch inp.lowercased(){
        case "male":
            return .Male
        case "female":
            return .Female
        default:
            return .Other
        }
    }
    
    func mapRole(inp: String) ->Role{
        if(inp.isEmpty){
            return .Unknown
        }
        switch inp.lowercased(){
        case "professor":
            return .Professor
        case "student":
            return .Student
        case "ta":
            return .TA
        default:
            return .Other
        }
    }
    func mapProgram(inp: String) -> Program{
        if(inp.isEmpty){
            return .Other
        }
        switch inp.lowercased(){
        case "meng":
            return .MENG
        case "ba":
            return .BA
        case "bs":
            return .BS
        case "ms":
            return .MS
        case "phd":
            return .PHD
        case "na":
            return .NotApplicable
        default:
            return .Other
        }
    }
    
    func mapPlan(inp: String) -> Plan{
        if(inp.isEmpty){
            return .Other
        }
        switch inp.lowercased(){
        case "cs":
            return .CS
        case "ece":
            return .ECE
        case "fintech":
            return .FinTech
        case "na":
            return .NotApplicable
        default:
            return .Other
        }
    }
}


#Preview {
    editDatabaseView(dataModel: DataBase.shared)
}
