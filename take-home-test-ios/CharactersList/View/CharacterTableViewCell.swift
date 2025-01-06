//
//  CharacterTableViewCell.swift
//  take-home-test-ios
//
//  Created by Amir Morsy on 02/01/2025.
//

import UIKit
import SwiftUI

class CharacterTableViewCell: UITableViewCell {
    private var hostingController: UIHostingController<CharacterRowView>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with character: Character) {
        if hostingController == nil {
            let characterRowView = CharacterRowView(character: character)
            hostingController = UIHostingController(rootView: characterRowView)
            guard let hostingController = hostingController else { return }
            contentView.addSubview(hostingController.view)
            
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        } else {
            hostingController?.rootView = CharacterRowView(character: character)
        }
    }
}
