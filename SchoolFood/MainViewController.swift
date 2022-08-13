//
//  ViewController.swift
//  SchoolFood
//
//  Created by 전도균 on 2022/08/11.
//

import UIKit

class MainViewController: UIViewController {
    
    let tableView = UITableView()
    
    let image = UIImage(named: "logo")
    
    let leftButton = UIButton(type: .system) // 충전
    let rightButton = UIButton(type: .system) // 결제
    
    let foodMenus = ["스페셜 마리", "불맛 중화비빔밥", "어간장 육감쫄면", "의성 마늘떡볶이"]
    let foodPrices = ["7500원", "8500원", "8000원", "9000원"]
    let foodImages = ["specailmari", "bibimbap", "jjolmyeon", "tteokbokki"]
    
    let foodCounts = [0, 0, 0, 0]
    
    let stackView = UIStackView()
       
    func printImage(){
        for foodImage in foodImages {
            print(foodImage)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let titleImageView = UIImageView(image: image)
//        let walletView = stackView.arrangedSubviews[0]
//        let wasteView = stackView.arrangedSubviews[1]
        
        view.addSubview(leftButton)
        view.addSubview(titleImageView)
        view.addSubview(rightButton)
        view.addSubview(tableView)
        view.addSubview(stackView)
        
        leftButton.setTitle("충전", for: .normal)
        leftButton.backgroundColor = .white
        leftButton.addTarget(self, action: #selector(didTapLeftButton(_:)), for: .touchUpInside)
        
        rightButton.setTitle("결제", for: .normal)
        rightButton.backgroundColor = .white
        rightButton.addTarget(self, action: #selector(didTapRightButton(_:)), for: .touchUpInside)
        
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.rowHeight = 70
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.backgroundColor = .red
        
        NSLayoutConstraint.activate([
            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            leftButton.centerYAnchor.constraint(equalTo: titleImageView.centerYAnchor),
            
            rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            rightButton.centerYAnchor.constraint(equalTo: titleImageView.centerYAnchor),
            
            titleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            titleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            titleImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            
            tableView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 350),
            
//            stackView.topAnchor.constraint(equalTo: tableView.bottomAnchor) test
        ])
        
    }
    
    @objc
    private func didTapLeftButton(_ sender: UIButton) {
        print(#function)
    }

    @objc
    private func didTapRightButton(_ sender: UIButton) {
        print(#function)
    }

}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodMenus.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell else { fatalError() }
        
        cell.myTitle.text = foodMenus[indexPath.row]
        cell.myTitle.sizeToFit()
        
        cell.mySubTitle.text = foodPrices[indexPath.row]
        cell.mySubTitle.sizeToFit()
        
        cell.countLabel.text = String(foodCounts[indexPath.row]) + "개"
        cell.countLabel.sizeToFit()
        
        cell.myImageView.image = UIImage(named: foodImages[indexPath.row])
        
        cell.selectionStyle = .none
        return cell
    }
    
}
