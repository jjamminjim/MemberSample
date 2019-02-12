//
//  DetailViewController.swift
//  MemberSample
//
//  Created by Jim Boyd on 2/11/19.
//  Copyright © 2019 Cabosoft. All rights reserved.
//

import UIKit
import DBC
import AlamofireImage

class DetailViewController: UIViewController {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var affiliationLabel: UILabel!
	@IBOutlet weak var birthdayLabel: UILabel!
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var forceButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Start with this disabled
		self.forceButton.isEnabled = false
		
		// Do any additional setup after loading the view, typically from a nib.
		configureView()
	}

	var detailItem: Member? {
		didSet {
		    // Update the view.
		    configureView()
		}
	}
	
	func configureView() {
		guard self.nameLabel != nil else {
			// View is not yet loaded...
			return
		}
		
		if let detail = self.detailItem {
			self.nameLabel.text = detail.fullName
			self.forceButton.isEnabled = true
			self.affiliationLabel.text = detail.affiliation.localizedString
			
			if let birthdate = detail.birthdate {
				self.birthdayLabel.text = "\(Localized.bornText) \(Member.dateFormatter.string(from: birthdate))"
			}
			else {
				self.birthdayLabel.text = Localized.agelessText
			}
			
			let placeholderImage = UIImage(named: "clone")
			check(placeholderImage != nil)
			
			if let url = detail.profileURL {
				let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
					size: profileImageView!.frame.size,
					radius: 20.0
				)
				
				self.profileImageView.af_setImage(withURL: url, placeholderImage: placeholderImage, filter: filter)
			}
			else {
				self.profileImageView.image = placeholderImage
			}
		}
	}

	@IBAction func useTheForce(_ sender: Any) {
		guard let detail = detailItem else {
			requireFailure("We should have a detail item set")
			return
		}
		
		let firstname = detail.firstName ?? Localized.dudeText
		var message = String.init(format: Localized.youGotNoForceText, firstname)
		
		if detail.forceSensitive {
			switch detail.affiliation {
			case .jedi, .resistance:
				message = String.init(format: Localized.useTheForce, firstname)
			case .firstOrder, .sith:
				message = String.init(format: Localized.weRatherYouDidntUseTheForcee, firstname)
			default:
				message = String.init(format: Localized.youGotNoForceText, firstname)
			}
		}
		
		let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		
		let OKAction = UIAlertAction(title: Localized.okText, style: .default) { (action) in
		}
		alertController.addAction(OKAction)

		self.present(alertController, animated: true, completion: nil)
	}
}

public enum Localized {
	static let okText = NSLocalizedString("Ok", comment: "DetailViewController")
	static let dudeText = NSLocalizedString("Dude", comment: "DetailViewController")
	static let bornText = NSLocalizedString("Born:", comment: "DetailViewController")
	static let agelessText = NSLocalizedString("Ageless:", comment: "DetailViewController")
	static let youGotNoForceText = NSLocalizedString("You got no force, %@!", comment: "DetailViewController")
	static let useTheForce = NSLocalizedString("Use the force, %@!", comment: "DetailViewController")
	static let weRatherYouDidntUseTheForcee = NSLocalizedString("We'ld rather you didn't, %@!", comment: "DetailViewController")
}
