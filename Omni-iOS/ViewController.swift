//
//  ViewController.swift
//  Omni-iOS
//
//  Created by Matic on 18/06/2019.
//  Copyright © 2019 Matic. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var searchController: UISearchController!
    var decodedData = CryptoData()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
        setupSearchController()
        
        apiCall { data in
            //self.decodedData = CryptoData()
            self.decodedData = data
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return decodedData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCell
        cell.cardTitle = decodedData[indexPath.row].name
        cell.cardItemTitle = decodedData[indexPath.row].symbol.uppercased()
        cell.cardItemSubtitle = String((decodedData[indexPath.row].current_price))
        cell.cardImageUrl = decodedData[indexPath.row].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 40, left: 8, bottom: 8, right: 8)
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // the top anchor is pinned to view.topAnchor otherwise, the weird "boost" effect on scroll appears.
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    func apiCall(completion: @escaping (CryptoData) -> Void) {
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            // ensure there is no error for this HTTP response
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            // ensure there is data returned from this HTTP response
            guard let data = data else {
                print("No data")
                return
            }
            // decode the data using JSONDecoder()
            guard let cryptoData = try? JSONDecoder().decode(CryptoData.self, from: data) else {
                print("Error decoding data.")
                return
            }
            completion(cryptoData)
        }.resume()
    }
}
