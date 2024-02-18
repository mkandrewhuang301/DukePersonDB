//
//  utilities.swift
//  Andrew
//
//  Created by Andrew Huang on 1/24/24.
//

import Foundation

enum Role : String, Codable {
    case Unknown = "Unknown" // has not been specified
    case Professor = "Professor"
    case TA = "TA"
    case Student = "Student"
    case Other = "Other" // has been specified, but is not Professor, TA, or Student
}

enum Gender : String, Codable {
    case Unknown = "Unknown" // has not been specified
    case Male = "Male"
    case Female = "Female"
    case Other = "Other" // has been specified, but is not “Male” or “Female”
}

struct DukePerson: CustomStringConvertible, Codable{
    let DUID: Int
    var netID: String
    var fName: String
    var lName: String
    var from: String // Where are you from
    var hobby: String // Your favorite pastime / hobby
    var languages: [String] // Up to 3 PROGRAMMING languages that you know.
    var moviegenre: String // Your favorite movie genre (Thriller, Horror, RomCom, etc)
    var gender: Gender
    var role: Role
    var program: Program
    var plan: Plan
    var team: String
    var picture: String
    var description: String{
        var pronoun = "";
        switch gender{
            case .Male:
                pronoun  = "he"
            case .Female:
                pronoun = "she"
            case .Unknown:
                pronoun = "they"
            case .Other:
                pronoun = "it"
        }
        var output: String = "\(fName) \(lName) is a \(role) at Duke University. \(fName) is from \(from) and likes to \(hobby). Their favorite movie genre is \(moviegenre). you can reach \(pronoun) at \(netID).duke.edu. Duke ID: \(DUID)"
        if role == .Student || role == .TA{
            output.append(" \(fName) is in the \(program) program studying \(plan).")
        }
        return output
    }
    init(DUID: Int, netID:String?, fName: String?, lName:String?, from: String?, hobby:String?, languages:[String]?, moviegenre:String?, gender:Gender?, role: Role?, program: Program?, plan: Plan?, picture: String?, team: String?){
        self.DUID = DUID
        self.netID = netID ?? "netID"
        self.fName = fName ?? "firstname"
        self.lName = lName ?? "lastname"
        self.from = from ?? "from"
        self.hobby = hobby ?? "hobby"
        self.languages = Array((languages ?? []).prefix(3))
        self.moviegenre = moviegenre ?? "moviegenre"
        self.gender = gender ?? .Unknown
        self.role = role ?? .Unknown
        self.program = program ?? .Other
        self.plan = plan ?? .Other
        self.team = ""
        self.picture = picture ?? ""
    }
}
enum Program : String, Codable {
    case NotApplicable = "NA"
    case MENG = "MENG"
    case BA = "BA"
    case BS = "BS"
    case MS = "MS"
    case PHD = "PhD"
    case Other = "Other"
}
enum Plan: String, Codable {
    case NotApplicable = "NA"
    case CS = "Computer Science"
    case ECE = "ECE"
    case FinTech = "FinTech"
    case Other = "Other"
}



