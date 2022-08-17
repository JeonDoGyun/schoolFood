//
//  ViewController.swift
//  SchoolFood
//
//  Created by 전도균 on 2022/08/11.
//

import UIKit
import Foundation

class MainViewController: UIViewController {
        
    let tableView = UITableView()
    
    let titleImageView = UIImageView(image: UIImage(named: "logo"))
    
    let leftButton = UIButton(type: .system) // 충전
    let rightButton = UIButton(type: .system) // 결제
    
    let foodMenus = ["스페셜 마리", "불맛 중화비빔밥", "어간장 육감쫄면", "의성 마늘떡볶이"]
    let foodPrices = [7500, 8500, 8000, 9000]
    let foodImages = ["specailmari", "bibimbap", "jjolmyeon", "tteokbokki"]
    
    let stackView = UIStackView()
    let walletLabel = UILabel()
    let paymentLabel = UILabel()
    
    let clearButton = UIButton()
    
    var nowMoney = 0
//    {    집 가서 넣어보기
//        willSet {
//
//        }
//    }
    var calculatedMoney = 0
    
    let numberFormatter = NumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
    }
    
    func style() {
        view.addSubview(leftButton)
        view.addSubview(titleImageView)
        view.addSubview(rightButton)
        view.addSubview(tableView)
        view.addSubview(stackView)
        view.addSubview(clearButton)
        
        leftButton.setTitle("충전", for: .normal)
        leftButton.backgroundColor = .white
        leftButton.addTarget(self, action: #selector(didTapLeftButton(_:)), for: .touchUpInside)
        
        rightButton.setTitle("결제", for: .normal)
        rightButton.backgroundColor = .white
        rightButton.addTarget(self, action: #selector(didTapRightButton(_:)), for: .touchUpInside)
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.rowHeight = 70
        
        stackView.addArrangedSubview(walletLabel)
        stackView.addArrangedSubview(paymentLabel)
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fillEqually
                
        clearButton.setTitle("초기화", for: .normal)
        clearButton.addTarget(self, action: #selector(didTapClearButton(_:)), for: .touchUpInside)
        clearButton.setTitleColor(.red, for: .normal)
        clearButton.sizeToFit()
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.string(for: nowMoney)
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.string(for: calculatedMoney)
        
        walletLabel.text = "내 지갑:           \(nowMoney)원"
        paymentLabel.text = "최종 결제금액:           \(calculatedMoney)원"
    }
    
    func layout() {
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            
            stackView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 80),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: clearButton.topAnchor, constant: -150)
        ])

    }
    
    @objc
    private func didTapLeftButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "지갑", message: "얼마를 충전할까요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: {_ in
            guard let myWallet = Int((alertController.textFields?.first?.text)!) else { return }
            self.nowMoney += myWallet
            guard let money = self.numberFormatter.string(for: self.nowMoney) else { return }
            self.walletLabel.text = "내 지갑:           \(money)원"
        })
        alertController.addTextField(configurationHandler: { textfield in
            textfield.keyboardType = .numberPad
        })
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }

    @objc
    private func didTapRightButton(_ sender: UIButton) {
        let charge = nowMoney - calculatedMoney
        let balance = calculatedMoney - nowMoney
        
        if nowMoney == 0 && calculatedMoney == 0 {
            let alertController1 = UIAlertController(title: "상품 없음", message: "먼저 상품을 추가하세요.", preferredStyle: .alert)
            let confirmAction1 = UIAlertAction(title: "확인", style: .default)
            alertController1.addAction(confirmAction1)
            present(alertController1, animated: true)
        } else if nowMoney < calculatedMoney {
            let alertController2 = UIAlertController(title: "잔액부족", message: "\(balance)원이 부족합니다.", preferredStyle: .alert)
            let confirmAction2 = UIAlertAction(title: "확인", style: .default)
            alertController2.addAction(confirmAction2)
            present(alertController2, animated: true)
        } else {
            let alertController3 = UIAlertController(title: "결제", message: "총 \(nowMoney)원을 결제하시겠습니까?", preferredStyle: .alert)
            let cancelAction3 = UIAlertAction(title: "취소", style: .cancel)
            let confirmAction3 = UIAlertAction(title: "확인", style: .default, handler: {_ in 
                self.nowMoney = charge
                self.calculatedMoney = 0
                guard let money = self.numberFormatter.string(for: self.nowMoney) else { return }
                self.walletLabel.text = "내 지갑:           \(money)원"
                self.paymentLabel.text = "최종 결제금액:           \(self.calculatedMoney)원"
            })
            alertController3.addAction(cancelAction3)
            alertController3.addAction(confirmAction3)
            present(alertController3, animated: true)
        }
    }
    
    @objc
    func didTapClearButton(_ sender: UIButton) {
        nowMoney = 0
        calculatedMoney = 0
        walletLabel.text = "내 지갑:           \(nowMoney)원"
        paymentLabel.text = "최종 결제금액:           \(calculatedMoney)원"
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
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        cell.mySubTitle.text = (numberFormatter.string(for: foodPrices[indexPath.row]) ?? "0") + "원"
        cell.mySubTitle.sizeToFit()
        
        cell.myImageView.image = UIImage(named: foodImages[indexPath.row])

        cell.selectionStyle = .none
        
        return cell
    }
    
}
