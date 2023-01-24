class Events : Codable{
    public let name: String
    public let date: Double
    
    init(json: [String: Any]) {
        date = json["date"] as? Double ?? 0
        name = json["name"] as? String ?? ""
    }
}
