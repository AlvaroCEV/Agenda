
import UIKit

class CreateEventViewController: UIViewController {
    
    @IBOutlet var dateCreate: UIDatePicker!
    
    @IBOutlet var eventCreate: UITextField!
    
    struct ResponseObject<T: Decodable>: Decodable {
        let form: T
    }
    
    @IBAction func submit(_ sender: Any) {
        
        let newEvent : String = eventCreate.text!
        let newDate = Int(dateCreate.date.timeIntervalSince1970 * 1000)
        
        
        let url = URL(string: "https://superapi.netlify.app/api/db/eventos")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let postEvent: [String : Any] = [
            "date" : newDate,
            "name" : newEvent
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postEvent, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            // do whatever you want with the `data`, e.g.:
            
            do {
                let responseObject = try JSONDecoder().decode(ResponseObject<Events>.self, from: data)
                print(responseObject)
            } catch {
                print(error) // parsing error
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
        }
        
        task.resume()
        /*
         // Prepare URL
         let url = URL(string: "https://superapi.netlify.app/api/db/eventos")
         guard let requestUrl = url else { fatalError() }
         // Prepare URL Request Object
         var request = URLRequest(url: requestUrl)
         request.httpMethod = "POST"
         
         // HTTP Request Parameters which will be sent in HTTP Request Body
         
         // Set HTTP Request Body
         request.httpBody = postEvent.data(using: String.Encoding.utf8)
         // Perform HTTP Request
         let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
         
         // Check for Error
         if let error = error {
         print("Error took place \(error)")
         return
         }
         
         // Convert HTTP Response Data to a String
         if let data = data, let dataString = String(data: data, encoding: .utf8) {
         print("Response data string:\n \(dataString)")
         }
         }
         task.resume()*/
    }
}
