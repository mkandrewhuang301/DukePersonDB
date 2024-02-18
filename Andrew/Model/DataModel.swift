//
//  DataModel.swift
//  Andrew
//
//  Created by Andrew Huang on 1/26/24.
//

import Foundation


final class DataBase: ObservableObject{
    
    @Published private var db: [Int: DukePerson] = [:]
    static let shared = DataBase()
    static let fileManager = FileManager.default
    //enter file path and access mydatabase file
    static let sandboxPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("myDatabase.json")
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    let defaultJsonName = "ece564sp24.json"
    
    
    func add(_ newPerson: DukePerson) -> Bool{
        if db[newPerson.DUID] != nil{
            return false
        }
        db[newPerson.DUID] = newPerson
        return true
    }
    func update(_ updatedPerson: DukePerson) -> Bool{
        if db[updatedPerson.DUID] != nil{
            db[updatedPerson.DUID] = updatedPerson
            return true
        }
        db[updatedPerson.DUID] = updatedPerson
        return false
    }
    func delete(_ DUID: Int)-> Bool{
        if db[DUID] != nil{
            db.removeValue(forKey: DUID)
            return true
        }
        return false
    }
    func find(_ DUID: Int) -> DukePerson?{
        return db[DUID]
        //return nil if not there, return value if there
    }
    func find(_ netID: String)-> DukePerson?{
        for(_, person ) in db{
            if person.netID == netID{ // overload should be fine
                return person
            }
        }
        return nil
    }
    func find(lastName lName: String, firstName fName: String = "*") -> [DukePerson]? {
        var result: [DukePerson]? = nil
        for(_, person) in db{
            if (person.fName.lowercased() == fName.lowercased() || fName == "*") &&
                (person.lName.lowercased() == lName.lowercased() || lName == "*"){
                if result == nil{
                    result = []
                }
                result?.append(person)
            }
        }
        return result
    }
    
    func list () -> String{
        var result: String = ""
        var count: Int = 0
        for(_, person) in db{
            count+=1
            let string = "\(count). \(person.fName) \(person.lName) , \(person.role),\(person.netID)@duke.edu ,  \(person.from), \(person.hobby), \(person.languages), \(person.moviegenre), \(person.gender), \(person.role), \(person.program), \(person.plan)\n\n"
            result += string
        }
        return result
    }
    func entries() -> [ DukePerson]{
        var result: [DukePerson] = []
        for(_, person) in db{
            result.append(person)
        }
        return result
    }
    func getTotal() -> Int{
        return db.count
    }
    func load(_ url:URL) -> Bool{
        //TODO: check if sandbox contains data. If yes, load and replace db. If not, use default ece564 data
        let tempData: Data
        //check if url is valid files existing outside app
        db = [:]
        if DataBase.fileManager.fileExists(atPath: url.path){
            do{
                tempData = try Data(contentsOf: url)
            }catch let error as NSError{
                print(error)
                return false
            }
            if let decoded = try? decoder.decode([DukePerson].self, from: tempData){
                for person in decoded{
                    let _ = add(person)
                }
            }
            return true
        }
        //if url is not valid ,just load the default json file, in app bundle
        let bundle = Bundle.main
        ///bottom is same as top half
        if let jsonFileURL = bundle.url(forResource: defaultJsonName, withExtension: nil){
            do {
                tempData = try Data(contentsOf: jsonFileURL)
            }catch let error as NSError{
                print(error)
                return false
            }
            if let decoded = try? decoder.decode([DukePerson].self, from: tempData){
                for person in decoded{
                    let _ = add(person)
                }
            }
            let _ = save()
            return true
        }
        return false
    }
    func save() -> Bool{
        //TODO: convert all entries to JSON and write JSON string to file. Return true, otherwise return false
        //let encoder = JSONEncoder()
        let values: [DukePerson] = Array(db.values)
        do{
            let data = try encoder.encode(values)
            try data.write(to:DataBase.sandboxPath)
            return true
        }catch{
            print("Error saving data")
            return false
        }
        
    }
    func stats() -> (mostCommonPlan: Plan?, planPercentage: Double, mostCommonProgram: Program?, programPercentage: Double) {
        var planCounts: [Plan: Int] = [:]
        var programCounts: [Program: Int] = [:]

        for (_, person) in db {
            let plan = person.plan
            planCounts[plan, default: 0] += 1

            let program = person.program
            programCounts[program, default: 0] += 1
        }

        var mostCommonPlan: Plan? = nil
        var planPercentage: Double = 0.0

        if let plan = planCounts.max(by: { $0.value < $1.value }) {
            mostCommonPlan = plan.key
            print("Most common plan: \(mostCommonPlan!.rawValue) (\(plan.value) occurrences)")
            planPercentage = Double(plan.value) / Double(self.getTotal())
            print("Plan percentage: \(planPercentage * 100)%")
        }

        var mostCommonProgram: Program? = nil
        var programPercentage: Double = 0.0

        if let program = programCounts.max(by: { $0.value < $1.value }) {
            mostCommonProgram = program.key
            print("Most common program: \(mostCommonProgram!.rawValue) (\(program.value) occurrences)")
            programPercentage = Double(program.value) / Double(self.getTotal())
            print("Program percentage: \(programPercentage * 100)%")
        }

        return (mostCommonPlan, planPercentage, mostCommonProgram, programPercentage)
    }

   func replaceDB(people: [DukePerson]) -> Bool{
       print("replacing")
       db  = [:]
      for person in people{
            db[person.DUID] = person
        }
       let res = self.save()
       
       
       return res
    }
    func updateDB(people: [DukePerson]) -> Bool{
        print("updating")
        for person in people{
            //print(person)
            let _ = update(person)
        }
        let res = self.save()
        
        return res
    }
    /*
    func download(website: String, auth: String, delegate: URLSessionDelegate?) -> Bool{
        ///set up URLSession to connect to website
        guard let url  = URL(string: website)else{
            return false
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        //set up credentials
        let credentials =  "ah629:\(auth)" //NEED TO ADD NETID
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
            session = URLSession(configuration: config, delegate: delegate, delegateQueue: nil)
        }else{
            session  = URLSession.shared
        }
        let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error updating entry: \(error.localizedDescription)")
                } else if let data = data {
                    // Process the received data (parse JSON, etc.)
                    if let decoded = try? decoder.decode([DukePerson].self, from: data){
                        for person in decoded{
                            print(person)
                            ///NOW JUST NEED TO PROCESS THE DATA AND SAVE IT
                        }
                    }
                    print("Received data: \(data)")
                }
            }
        task.resume()
        return true
    }
     */
     
}
