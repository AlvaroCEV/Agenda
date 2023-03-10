
import UIKit

import Foundation

class RegisterViewController: UIViewController {
    
    @IBOutlet var User: UITextField!
    
    @IBOutlet var Password: UITextField!
    
    @IBOutlet var ConfirmPassword: UITextField!
    
    
    @IBAction func Register(_ sender: Any) {
        
        
        let newUser : String = User.text!
        let newPassword: String = Password.text!
        let confirmNewPassword: String = ConfirmPassword.text!
        
        let url = URL(string: "https://superapi.netlify.app/api/register")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let postUser: [String : Any] = [
            "user" : newUser,
            "pass" : newPassword
        ]
        
        if newPassword == confirmNewPassword {
            
                
        struct ResponseObject<T: Decodable>: Decodable {
            let form: T
        }
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postUser, options: .prettyPrinted)
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
                let responseObject = try JSONDecoder().decode(ResponseObject<Users>.self, from: data)
                print(responseObject)
            } catch {
                print(error) // parsing error
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
            DispatchQueue.main.async{
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        task.resume()
        } else {
            return
        }

    }
    
}
