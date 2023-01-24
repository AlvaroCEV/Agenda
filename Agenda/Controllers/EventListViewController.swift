
import UIKit

class EventListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate {
    var events: [Events] = []
    @IBOutlet var EventTable: UITableView!
    let url = URL(string: "https://superapi.netlify.app/api/db/eventos")
    func loadEvents(){
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
                    guard let data = data,
                          let response = response as? HTTPURLResponse,
                          response.statusCode == 200, error == nil else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                self.events.removeAll()
                for name in json as! [[String : Any]] {
                    self.events.append(Events(json: name))
                }
                DispatchQueue.main.async{
                    self.EventTable.reloadData()
                }
            } catch let errorJson {
                print(errorJson)
            }
        //            do {
        //                print(data)
        //                let event = try JSONDecoder().decode([Events].self, from: data)
        //                print(event)
        //            } catch {
        //                print("error: ", error)
        //                print(error.localizedDescription)
        //            }
                }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EventTable.dataSource = self
        EventTable.delegate = self
        loadEvents()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventRow: EventsRow = tableView.dequeueReusableCell(withIdentifier: "eventRowID", for: indexPath) as! EventsRow
        let eventss = events[indexPath.row]
        let newTime =
        TimeInterval(events[indexPath.row].date / 1000)
        let newDate = Date(timeIntervalSince1970: newTime)
        
        eventRow.name.text = eventss.name
        eventRow.date.text = newDate.formatted().description
        
        return eventRow
    }
    
    @IBAction func Reload(_ sender: Any) {
        loadEvents()
    }
    
    @IBAction func CreateEvent(_ sender: Any) {
        performSegue(withIdentifier: "EventCreate", sender: sender)
    }
}
    
