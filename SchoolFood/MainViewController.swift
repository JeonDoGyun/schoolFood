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
    
    var quantities = [0, 0, 0, 0]
    
    let stackView = UIStackView()
    let walletLabel = UILabel()
    let paymentLabel = UILabel()
    
    let clearButton = UIButton()
    
    var nowMoney = 0 {
        willSet {
            walletLabel.text = "내 지갑:       \(newValue.toDecimalFormat())원"
        }
    }

    var calculatedMoney = 0 {
        willSet {
            paymentLabel.text = "최종 결제금액:   \(newValue.toDecimalFormat())원"
        }
    }
    
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
            stackView.bottomAnchor.constraint(equalTo: clearButton.topAnchor, constant: -150),
        ])

    }
    
    func resetAll() {
        nowMoney = 0
        calculatedMoney = 0
        quantities = [0, 0, 0, 0]
        tableView.reloadData()
    }
    
    @objc
    private func didTapLeftButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "지갑", message: "얼마를 충전할까요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: {_ in
            guard let myWallet = Int((alertController.textFields?.first?.text)!) else { return }
            self.nowMoney += myWallet
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
            let alertController2 = UIAlertController(title: "잔액부족", message: "\(balance.toDecimalFormat())원이 부족합니다.", preferredStyle: .alert)
            let confirmAction2 = UIAlertAction(title: "확인", style: .default)
            alertController2.addAction(confirmAction2)
            present(alertController2, animated: true)
        } else {
            let alertController3 = UIAlertController(title: "결제", message: "총 \(nowMoney)원을 결제하시겠습니까?", preferredStyle: .alert)
            let cancelAction3 = UIAlertAction(title: "취소", style: .cancel)
            let confirmAction3 = UIAlertAction(title: "확인", style: .default, handler: {_ in 
                self.nowMoney = charge
                self.calculatedMoney = 0
                self.resetAll()
                self.nowMoney = charge
            })
            alertController3.addAction(cancelAction3)
            alertController3.addAction(confirmAction3)
            present(alertController3, animated: true)
        }
    }
    
    @objc
    func didTapClearButton(_ sender: UIButton) {
        resetAll()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Menu.allCases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell else { fatalError() }
        
        let menu = Menu.allCases[indexPath.row]
        let quantity = quantities[indexPath.row]
        cell.tag = indexPath.row
        cell.setData(menu: menu, quantity: quantity)
        cell.selectionStyle = .none
        cell.delegate = self
        
        return cell
    }
    
}

extension MainViewController: CustomTableViewCellDelegate {
    func didTapStepper(amount: Int, quantity: Int, tag: Int) {
        quantities[tag] = quantity
        calculatedMoney += amount
    }
    
}

extension Int {
    func toDecimalFormat() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let price = formatter.string(for: self) else { return "Error"}
        
        return price
    }
}
