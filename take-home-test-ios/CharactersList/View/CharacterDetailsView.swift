//
//  CharacterDetailsView.swift
//  take-home-test-ios
//
//  Created by Amir Morsy on 02/01/2025.
//

import SwiftUI
import UIKit

class CharacterDetailsViewController: UIViewController {
    
    private let viewModel: CharacterDetailsViewModel
    
    private let backButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            button.tintColor = .black
            button.backgroundColor = .white
            button.layer.cornerRadius = 25
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.2
            button.layer.shadowRadius = 4
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        private let characterImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 20
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        private let nameLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 24)
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let speciesAndGenderStack: UIStackView = {
            let speciesLabel = UILabel()
            speciesLabel.font = UIFont.systemFont(ofSize: 16)
            speciesLabel.textColor = .black
            
            let circleView = UIView()
            circleView.backgroundColor = .gray
            circleView.layer.cornerRadius = 2.5
            circleView.translatesAutoresizingMaskIntoConstraints = false
            
            let genderLabel = UILabel()
            genderLabel.font = UIFont.systemFont(ofSize: 16)
            genderLabel.textColor = .gray
            
            let stack = UIStackView(arrangedSubviews: [speciesLabel, circleView, genderLabel])
            stack.axis = .horizontal
            stack.spacing = 8
            stack.alignment = .center
            stack.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                circleView.widthAnchor.constraint(equalToConstant: 5),
                circleView.heightAnchor.constraint(equalToConstant: 5)
            ])
            
            return stack
        }()
        
        private let locationLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            label.textColor = .gray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let statusLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            label.textAlignment = .center
            label.textColor = .black
            label.layer.cornerRadius = 8
            label.clipsToBounds = true
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    init(viewModel: CharacterDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureView()
    }

    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(characterImageView)
        view.addSubview(backButton)
        view.addSubview(nameLabel)
        view.addSubview(speciesAndGenderStack)
        view.addSubview(locationLabel)
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: view.topAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            characterImageView.heightAnchor.constraint(equalToConstant: 500),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -8),
            
            statusLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statusLabel.widthAnchor.constraint(equalToConstant: 80),
            statusLabel.heightAnchor.constraint(equalToConstant: 35),
            
            speciesAndGenderStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            speciesAndGenderStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            locationLabel.topAnchor.constraint(equalTo: speciesAndGenderStack.bottomAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
    }

    private func configureView() {
        characterImageView.loadImage(from: viewModel.character.image, placeholder: UIImage(named: "photo"))
        nameLabel.text = viewModel.character.name
        
        if let speciesLabel = speciesAndGenderStack.arrangedSubviews[0] as? UILabel,
           let genderLabel = speciesAndGenderStack.arrangedSubviews[2] as? UILabel {
            speciesLabel.text = viewModel.character.species
            genderLabel.text = viewModel.character.gender
        }
                
        let attributedText = NSMutableAttributedString(
            string: "Location: ",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 18),
                .foregroundColor: UIColor.black
            ]
        )

        attributedText.append(NSAttributedString(
            string: viewModel.character.location.name,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.gray
            ]
        ))

        locationLabel.attributedText = attributedText
        
        statusLabel.text = viewModel.character.status.rawValue
        switch viewModel.character.status {
        case .unknown:
            statusLabel.backgroundColor = .white
            statusLabel.layer.cornerRadius = 16
            statusLabel.layer.borderColor = UIColor.gray.cgColor
            statusLabel.layer.borderWidth = 1
        default:
            statusLabel.backgroundColor = viewModel.character.status == .alive ? UIColor(named: "AliveColor") : UIColor(named: "DeadColor")
            statusLabel.layer.borderWidth = 0
        }
    }
    
    @objc func didTapBackButton(sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// A Version of the details screen using SWIFTUI

//struct CharacterDetailsView: View {
//    @Environment(\.dismiss) private var dismiss
//    @ObservedObject var viewModel: CharacterDetailsViewModel
//    
//    var body: some View {
//        VStack {
//            ZStack(alignment: .topLeading){
//
//                AsyncImage(url: URL(string: viewModel.character.image)) { image in
//                    image
//                        .resizable()
//                        .frame(maxWidth: .infinity, maxHeight: 500)
//                        .scaledToFit()
//                        .cornerRadius(20)
//                } placeholder: {
//                    Image("photo").frame(width: 40)
//                }
//                
//                Button(action: {
//                    dismiss()
//                }) {
//                    Image(systemName: "arrow.left")
//                        .font(.system(size: 20, weight: .bold))
//                        .foregroundColor(Color.black)
//                        .padding()
//                        .background(Circle().fill(Color.white))
//                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
//                }
//                .buttonStyle(PlainButtonStyle())
//                .padding(.top, 70)
//                .padding(.leading, 20)
//            }
//            
//            
//            HStack(alignment: .top) {
//                VStack(alignment: .leading) {
//                    Text(viewModel.character.name)
//                        .font(.system(size: 24, weight: .bold))
//                        .foregroundColor(Color.black)
//                    
//                    HStack {
//                        Text(viewModel.character.species)
//                            .font(.system(size: 16, weight: .bold))
//                            .foregroundColor(Color.black)
//                        
//                        Circle().fill(Color.gray).frame(width: 5, height: 5)
//                        
//                        Text(viewModel.character.gender)
//                            .font(.system(size: 16, weight: .bold))
//                            .foregroundColor(Color.gray)
//                    }
//                    
//                    Spacer().frame(height: 30)
//                    
//                    HStack {
//                        Text("Location: ")
//                            .font(.system(size: 20, weight: .bold))
//                            .foregroundColor(Color.black)
//                        
//                        Text(viewModel.character.location.name)
//                            .font(.system(size: 18, weight: .bold))
//                            .foregroundColor(Color.gray)
//                    }
//                }
//                
//                Spacer()
//                
//                Text(viewModel.character.status.rawValue)
//                    .font(.system(size: 16, weight: .medium))
//                    .frame(width: 70, height: 30)
//                    .foregroundColor(.black)
//                    .background(Color.cyan)
//                    .cornerRadius(16)
//            }.padding(20)
//            
//            Spacer()
//        }.edgesIgnoringSafeArea(.top)
//    }
//}
