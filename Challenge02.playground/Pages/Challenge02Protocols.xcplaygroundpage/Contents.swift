import UIKit

// LOGIN SYSTEM


protocol UserData {
    var username:String {get}
    var email:String {get}
    var cellPhone:String {get}
}

enum Permissions {
    case Admin
    case Normal
}


struct AuthUser:UserData {
    var permissions: Permissions
    
    var username: String
    
    var email: String
    
    var cellPhone: String
    
    var securityToken:String
}


class Users {
    var users:[AuthUser] = []
    
    func getUsersByusername(username:String) -> AuthUser? {
        let findedUser = users.first{user in user.username == username}
        return findedUser
    }
    
    func addToList(newUser:AuthUser){
        users.append(newUser)
    }
}


enum AuthenticationError:Error {
    case InvalidCredentials
    case AlreadyExist
}

class Authentication {
    private var usersQuery = Users()
}

protocol AuthSignIn {
    mutating func signIn(username:String ,password:String) throws -> String?
}

protocol AuthSignUp {
    mutating func signUp(username:String,password:String,email:String,cellPhone:String) throws -> String?
    
    func checkAlreadyExists(username:String) -> Bool
    func generateToken() -> String
}

extension Authentication:AuthSignIn {
    func signIn(username: String, password: String) throws -> String? {
        let user = self.usersQuery.getUsersByusername(username: username)
        if(user != nil) {
            return user?.securityToken
        } else {
            throw AuthenticationError.InvalidCredentials
        }
    }
}

extension Authentication:AuthSignUp {
    
    func signUp(username: String, password: String, email: String,cellPhone:String) throws -> String? {
        if(checkAlreadyExists(username:username)){
            throw AuthenticationError.AlreadyExist
        } else {
            let token = generateToken()
            let newUser = AuthUser(permissions: Permissions.Normal, username: username, email: email, cellPhone: cellPhone, securityToken: token)
            
            self.usersQuery.addToList(newUser:newUser)
            return newUser.securityToken
        }
    }
    
    func checkAlreadyExists(username: String) -> Bool {
        if self.usersQuery.getUsersByusername(username: username) != nil {
            return true
        } else {
            return false
        }
    }
    
    func generateToken() -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
         let length = UInt32(letters.length)

         var randomString = ""

         for _ in 0 ..< length {
             let rand = arc4random_uniform(length)
             var nextChar = letters.character(at: Int(rand))
             randomString += NSString(characters: &nextChar, length: 1) as String
         }

         return randomString
    }
}

func onStart() throws {
    let auth = Authentication()
    
    do{
        try auth.signUp(username: "Stevon", password: "FERREIRA", email: "STEVON.FERREIRA@GMAIL.COM", cellPhone: "99999-9999")
        let token = try auth.signIn(username: "Stevon", password: "FERREIRA")
        print("Entrou com sucesso!")
    } catch  {
        print(error)
    }
}

try onStart()
