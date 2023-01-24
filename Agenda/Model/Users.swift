class Users : Decodable {
    var user: String?
    var pass: String?
    
    init(json: [String : Any])  {
        user = json["user"] as? String ?? ""
        pass = json["pass"] as? String ?? ""
    }
}

