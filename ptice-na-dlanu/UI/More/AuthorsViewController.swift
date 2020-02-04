//
//  AuthorsViewController.swift
//  ptice-na-dlanu
//
//  Created by Jelena on 03/02/2020.
//  Copyright © 2020 Nikola Milic. All rights reserved.
//

import UIKit

struct AuthorData {
    let birdName: String
    let type: String
    let link: String
    let authorName: String
}

class AuthorsViewController: UIViewController, Storyboarded {

    @IBOutlet var authorsTable: UITableView!
    
    var dataSource = [AuthorData]()

    weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    fileprivate func loadData() {
        dataSource.removeAll()
        
        if let path = Bundle.main.path(forResource: "scheme", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
            let birds = try? JSONDecoder().decode([Bird].self, from: data) {
            
            for bird in birds {
                if bird.pesma != "" {
                    dataSource.append(AuthorData.init(birdName: bird.srpskiNazivVrste, type: "Pesma", link: bird.pesma, authorName: bird.autorPesme))
                }
                
                if bird.zov != "" {
                    dataSource.append(AuthorData.init(birdName: bird.srpskiNazivVrste, type: "Zov", link: bird.zov, authorName: bird.autorZova))
                }
                
                if bird.pesmaZenke != "" {
                    dataSource.append(AuthorData.init(birdName: bird.srpskiNazivVrste, type: "Zov ženke", link: bird.pesmaZenke, authorName: bird.autorPesmeZenke))
                }
                
                if bird.zovMladih != "" {
                    dataSource.append(AuthorData.init(birdName: bird.srpskiNazivVrste, type: "Zov mladunaca", link: bird.zovMladih, authorName: bird.autorZovaMladih))
                }
                
                if bird.letniZov != "" {
                    dataSource.append(AuthorData.init(birdName: bird.srpskiNazivVrste, type: "Zov u letu", link: bird.letniZov, authorName: bird.autorLetnogZova))
                }
                
                if bird.zovUzbune != "" {
                    dataSource.append(AuthorData.init(birdName: bird.srpskiNazivVrste, type: "Uzbuna", link: bird.zovUzbune, authorName: bird.autorZovaUzbune))
                }
            }
        }
    }
}

extension AuthorsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "authorCell", for: indexPath)
        let authorData = dataSource[indexPath.row]
        
        cell.textLabel?.text = authorData.birdName + " - " + authorData.type
        cell.detailTextLabel?.text = authorData.authorName
        
        return cell
    }
}

extension AuthorsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let authorData = dataSource[indexPath.row]
        
        if let link = URL.init(string: authorData.link) {
            UIApplication.shared.open(link)
        }
    }
}
