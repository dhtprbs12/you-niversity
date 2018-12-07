//
//  WannaBeMentorView.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 2. 22..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Material
import PureLayout
import DLRadioButton

class WannaBeMentorView: UIView{
    
    var backgroundImage: UIImageView!
    var backgroundImageLabel: UILabel!
    var profileImage: UIImageView!
    var profileImageLabel: UILabel!
    var nicknameLabel:UILabel!
    var nicknameTextField:ErrorTextField!
    var univNameLabel: UILabel!
    var univTextField: ErrorTextField!
    var majorLabel: UILabel!
    var majorTextField: ErrorTextField!
    var whoCanBeMentoredLabel: UILabel!
    var maximumSelectionBeMentored: UILabel!
    var elementaryButton: DLRadioButton!
    var middleSchoolButton: DLRadioButton!
    var highSchoolButton: DLRadioButton!
    var collegeButton: DLRadioButton!
    var mentoringFieldLabel: UILabel!
    var maximumMentoringField: UILabel!
    var outsideActivityButton: DLRadioButton!
    var collegeLifeButton: DLRadioButton!
    var friendAndRelationshipButton: DLRadioButton!
    var tripAndHobbyButton: DLRadioButton!
    var employmentButton: DLRadioButton!
    var tutoringButton: DLRadioButton!
    var fashionAndBeautyButton: DLRadioButton!
    var satAndApplicationButton: DLRadioButton!
    var mentorIntroSelf: UILabel!
    var maximumIntroSelf: UILabel!
    var mentorIntroTextView: TextView!
    var mentoringInfo: UILabel!
    var maximumMentoringInfo: UILabel!
    var mentoringInfoTextView: TextView!
    var mentorCareerLabel: UILabel!
    var mentorSchools: UILabel!
    var mentorSchoolsTextView: TextView!
    var submitButton: RaisedButton!
    var placeholder: UILabel!
    
    var shouldSetupConstraints = true
    //UIView overrided methods
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        if(shouldSetupConstraints){
            //AutoLayout constraints
            let edgesInset: CGFloat = 10.0
            
            
            //backgroundImage
            backgroundImage.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .bottom)
            //profileImage
            profileImage.autoPinEdge(.top, to: .top, of: backgroundImage, withOffset: edgesInset)
            //make it center
            profileImage.autoAlignAxis(.vertical, toSameAxisOf: self)
            //profileImageLabel
            profileImageLabel.autoPinEdge(.top, to: .bottom, of: profileImage, withOffset: 2)
            profileImageLabel.autoAlignAxis(.vertical, toSameAxisOf: self)
            //backgroundImageLabel
            backgroundImageLabel.autoPinEdge(toSuperviewEdge: .right, withInset: edgesInset)
            backgroundImageLabel.autoPinEdge(.bottom, to: .bottom, of: backgroundImage, withOffset: -5)
            //nameLabel
            nicknameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            nicknameLabel.autoPinEdge(.top, to: .bottom, of: backgroundImage, withOffset: edgesInset + 20)
            //nameTextField
            nicknameTextField.autoPinEdge(.top, to: .top, of: nicknameLabel)
            nicknameTextField.autoPinEdge(.left, to: .right, of: nicknameLabel, withOffset: edgesInset)
            nicknameTextField.autoPinEdge(.right, to: .right, of: self, withOffset: -5)
            //univNameLabel
            univNameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            univNameLabel.autoPinEdge(.top, to: .bottom, of: nicknameTextField, withOffset: edgesInset + 20)
            //univTextField
            univTextField.autoPinEdge(.top, to: .top, of: univNameLabel)
            univTextField.autoPinEdge(.left, to: .right, of: univNameLabel, withOffset: edgesInset)
            univTextField.autoPinEdge(.right, to: .right, of: self, withOffset: -5)
            //majorNameLabel
            majorLabel.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            majorLabel.autoPinEdge(.top, to: .bottom, of: univTextField, withOffset: edgesInset + 20)
            //majorTextField
            majorTextField.autoPinEdge(.top, to: .top, of: majorLabel)
            majorTextField.autoPinEdge(.left, to: .right, of: majorLabel, withOffset: edgesInset)
            majorTextField.autoPinEdge(.right, to: .right, of: self, withOffset: -5)
            whoCanBeMentoredLabel.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            whoCanBeMentoredLabel.autoPinEdge(.top, to: .bottom, of: majorTextField, withOffset: edgesInset)
            //maximumSelectionBeMentored
            maximumSelectionBeMentored.autoPinEdge(.bottom, to: .bottom, of: whoCanBeMentoredLabel)
            maximumSelectionBeMentored.autoPinEdge(.left, to: .right, of: whoCanBeMentoredLabel, withOffset: 5)
            //BeMentoredButtons
            elementaryButton.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            elementaryButton.autoPinEdge(.top, to: .bottom, of: whoCanBeMentoredLabel, withOffset: 5)
            //middleSchool
            middleSchoolButton.autoPinEdge(.top, to: .top, of: elementaryButton)
            middleSchoolButton.autoPinEdge(.right, to: .right, of: self, withOffset: 5)
            highSchoolButton.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            highSchoolButton.autoPinEdge(.top, to: .bottom, of: elementaryButton, withOffset: 5)
            //collegeButton
            collegeButton.autoPinEdge(.top, to: .top, of: highSchoolButton)
            collegeButton.autoPinEdge(.right, to: .right, of: self, withOffset: 5)
            //MentoringField
            mentoringFieldLabel.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            mentoringFieldLabel.autoPinEdge(.top, to: .bottom, of: highSchoolButton, withOffset: edgesInset)
            //MaximumMentoringField
            maximumMentoringField.autoPinEdge(.bottom, to: .bottom, of: mentoringFieldLabel)
            maximumMentoringField.autoPinEdge(.left, to: .right, of: mentoringFieldLabel, withOffset: 5)
            //outsideActivityButton
            outsideActivityButton.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            outsideActivityButton.autoPinEdge(.top, to: .bottom, of: mentoringFieldLabel, withOffset: 15)
            //collegeLifeButton
            collegeLifeButton.autoPinEdge(.top, to: .top, of: outsideActivityButton)
            collegeLifeButton.autoPinEdge(.right, to: .right, of: self, withOffset: 5)
            //collegeLifeButton.autoPinEdge(.left, to: .right, of: outsideActivityButton, withOffset: 5)
            //friendship&relationshipButton
            friendAndRelationshipButton.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            friendAndRelationshipButton.autoPinEdge(.top, to: .bottom, of: outsideActivityButton, withOffset: 15)
            //trip&hobbyButton
            tripAndHobbyButton.autoPinEdge(.top, to: .top, of: friendAndRelationshipButton)
            tripAndHobbyButton.autoPinEdge(.right, to: .right, of: self, withOffset: 5)
            //tripAndHobbyButton.autoPinEdge(.left, to: .right, of: friendAndRelationshipButton, withOffset: 5)
            //employmentButton
            employmentButton.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            employmentButton.autoPinEdge(.top, to: .bottom, of: friendAndRelationshipButton, withOffset: 15)
            //tutoringButton
            tutoringButton.autoPinEdge(.top, to: .top, of: employmentButton)
            tutoringButton.autoPinEdge(.right, to: .right, of: self, withOffset: 5)
            //tutoringButton.autoPinEdge(.left, to: .right, of: employmentButton, withOffset: 5)
            //fashion&beautyButton
            fashionAndBeautyButton.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            fashionAndBeautyButton.autoPinEdge(.top, to: .bottom, of: employmentButton, withOffset: 15)
            //sat&applicationButton
            satAndApplicationButton.autoPinEdge(.top, to: .top, of: fashionAndBeautyButton)
            satAndApplicationButton.autoPinEdge(.right, to: .right, of: self, withOffset: 5)
            //satAndApplicationButton.autoPinEdge(.left, to: .right, of: fashionAndBeautyButton, withOffset: 5)
            //MentorIntro
            mentorIntroSelf.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            mentorIntroSelf.autoPinEdge(.top, to: .bottom, of: fashionAndBeautyButton, withOffset: edgesInset)
            //maximumMentorIntro
            maximumIntroSelf.autoPinEdge(.top, to: .top, of: mentorIntroSelf)
            maximumIntroSelf.autoPinEdge(.left, to: .right, of: mentorIntroSelf, withOffset: 5)
            //mentorIntroTextView
            mentorIntroTextView.autoPinEdge(.top, to: .bottom, of: mentorIntroSelf, withOffset: edgesInset)
            mentorIntroTextView.autoPinEdge(toSuperviewEdge: .left, withInset: 5)
            mentorIntroTextView.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            //MentoringInfo
            mentoringInfo.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            mentoringInfo.autoPinEdge(.top, to: .bottom, of: mentorIntroTextView, withOffset: edgesInset)
            //maximumMentoringInfo
            maximumMentoringInfo.autoPinEdge(.bottom, to: .bottom, of: mentoringInfo)
            maximumMentoringInfo.autoPinEdge(.left, to: .right, of: mentoringInfo, withOffset: 5)
            //MentoringInfoTextView
            mentoringInfoTextView.autoPinEdge(.top, to: .bottom, of: mentoringInfo, withOffset: edgesInset)
            mentoringInfoTextView.autoPinEdge(toSuperviewEdge: .left, withInset: 5)
            mentoringInfoTextView.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            //submitButton
            submitButton.autoPinEdge(.top, to: .bottom, of: mentoringInfoTextView, withOffset: 10)
            submitButton.autoPinEdge(toSuperviewEdge: .left, withInset: 5)
            submitButton.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    
    func initUI(){
        self.backgroundColor = UIColor.white
        
        let buttonSize:CGFloat = self.frame.size.width / 2
        let labelWidthSize:CGFloat = self.frame.size.width / 4
        //backgroundImage
        backgroundImage = UIImageView(frame:CGRect.zero)
        backgroundImage.backgroundColor = App.mainColor
        backgroundImage.autoSetDimension(.height, toSize: self.frame.size.width/3 + 30)
        backgroundImage.isUserInteractionEnabled = true
        backgroundImage.tag = 1
        addSubview(backgroundImage)
        //backgroundLabel
        backgroundImageLabel = UILabel()
        backgroundImageLabel.tag = 1
        backgroundImageLabel.textColor = UIColor.white
        backgroundImageLabel.font = UIFont.boldSystemFont(ofSize: 14)
        backgroundImageLabel.attributedText = NSAttributedString(string: "Select Background Image", attributes:
            [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        backgroundImageLabel.isUserInteractionEnabled = true
        addSubview(backgroundImageLabel)
        //backgroundImageLabel.bringSubview(toFront: backgroundImage)
        //profileImage
        profileImage = UIImageView()
        profileImage.autoSetDimension(.height, toSize: 60.0)
        profileImage.autoSetDimension(.width, toSize: 60.0)
        profileImage.isUserInteractionEnabled = true
        profileImage.layer.cornerRadius = 60 / 2
        profileImage.borderColor = UIColor.white
        profileImage.borderWidthPreset = .border3
        profileImage.clipsToBounds = true
        profileImage.image = UIImage(named: "ic_face_white")
        profileImage.tag = 2
        addSubview(profileImage)
        //profileImage.bringSubview(toFront: backgroundImage)
        //profileImageLabel
        profileImageLabel = UILabel()
        profileImageLabel.tag = 2
        profileImageLabel.textColor = UIColor.white
        profileImageLabel.font = UIFont.boldSystemFont(ofSize: 14)
        profileImageLabel.attributedText = NSAttributedString(string: "Select Profile", attributes:
            [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        profileImageLabel.isUserInteractionEnabled = true
        addSubview(profileImageLabel)
        //nameLabel
        nicknameLabel = UILabel()
        nicknameLabel.text = "Nickname"
        nicknameLabel.autoSetDimension(.width, toSize: labelWidthSize)
        nicknameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        addSubview(nicknameLabel)
        //nameTextField
        nicknameTextField = ErrorTextField()
        nicknameTextField.placeholder = " Nickname?"
        nicknameTextField.borderStyle = .line
        nicknameTextField.tag = 1
        nicknameTextField.returnKeyType = .next
        //this causes contraint error
        //nameTextField.autoSetDimension(.width, toSize: textFieldWidthSize)
        nicknameTextField.layer.borderWidth = 1
        addSubview(nicknameTextField)
        //univLabel
        univNameLabel = UILabel()
        univNameLabel.text = "University"
        univNameLabel.autoSetDimension(.width, toSize: labelWidthSize)
        univNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        univNameLabel.adjustsFontSizeToFitWidth = true
        addSubview(univNameLabel)
        //univTextField
        univTextField = ErrorTextField()
        univTextField.placeholder = "Type the university to find"
        //univTextField.autoSetDimension(.width, toSize: textFieldWidthSize)
        univTextField.borderStyle = .line
        univTextField.spellCheckingType = .no
        univTextField.layer.borderWidth = 1
        univTextField.returnKeyType = .next
        univTextField.tag = 2
        addSubview(univTextField)
        //majorLabel
        majorLabel = UILabel()
        majorLabel.text = "Major"
        majorLabel.autoSetDimension(.width, toSize: labelWidthSize)
        majorLabel.font = UIFont.boldSystemFont(ofSize: 17)
        addSubview(majorLabel)
        //majorTextField
        majorTextField = ErrorTextField()
        majorTextField.placeholder = "Type the major to find"
        //majorTextField.autoSetDimension(.width, toSize: textFieldWidthSize)
        majorTextField.borderStyle = .line
        majorTextField.layer.borderWidth = 1
        majorTextField.tag = 3
        majorTextField.spellCheckingType = .no
        majorTextField.returnKeyType = .done
        addSubview(majorTextField)
        //whoCanBeMentored?
        whoCanBeMentoredLabel = UILabel()
        whoCanBeMentoredLabel.text = "Who Can Be Mentored?"
        whoCanBeMentoredLabel.font = UIFont.boldSystemFont(ofSize: 17)
        addSubview(whoCanBeMentoredLabel)
        //maximumSelctionBeMentored
        maximumSelectionBeMentored = UILabel()
        maximumSelectionBeMentored.textColor = UIColor.red
        maximumSelectionBeMentored.text = "1 item at least"
        maximumSelectionBeMentored.font = UIFont.systemFont(ofSize: 13)
        addSubview(maximumSelectionBeMentored)
        //elementaryButton
        elementaryButton = DLRadioButton()
        elementaryButton.isMultipleSelectionEnabled = true
        elementaryButton.autoSetDimension(.width, toSize: buttonSize)
        elementaryButton.setTitle("Primary", for: .normal)
        elementaryButton.setTitleColor(App.mainColor, for: .normal)
        elementaryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        elementaryButton.contentHorizontalAlignment = .left
        
        addSubview(elementaryButton)
        //middleSchoolButton
        middleSchoolButton = DLRadioButton()
        middleSchoolButton.isMultipleSelectionEnabled = true
        middleSchoolButton.autoSetDimension(.width, toSize: buttonSize)
        middleSchoolButton.setTitle("Middle", for: .normal)
        middleSchoolButton.setTitleColor(App.mainColor, for: .normal)
        middleSchoolButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        middleSchoolButton.contentHorizontalAlignment = .left
        
        addSubview(middleSchoolButton)
        //highSchoolButton
        highSchoolButton = DLRadioButton()
        highSchoolButton.isMultipleSelectionEnabled = true
        highSchoolButton.autoSetDimension(.width, toSize: buttonSize)
        highSchoolButton.setTitle("High", for: .normal)
        highSchoolButton.setTitleColor(App.mainColor, for: .normal)
        highSchoolButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        highSchoolButton.contentHorizontalAlignment = .left
        
        addSubview(highSchoolButton)
        //collegeButton
        collegeButton = DLRadioButton()
        collegeButton.isMultipleSelectionEnabled = true
        collegeButton.autoSetDimension(.width, toSize: buttonSize)
        collegeButton.setTitle("College", for: .normal)
        collegeButton.setTitleColor(App.mainColor, for: .normal)
        collegeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        collegeButton.contentHorizontalAlignment = .left
        
        addSubview(collegeButton)
        //mentoringField
        mentoringFieldLabel = UILabel()
        mentoringFieldLabel.text = "Mentoring Field"
        mentoringFieldLabel.font = UIFont.boldSystemFont(ofSize: 17)
        addSubview(mentoringFieldLabel)
        //maximummentoringField
        maximumMentoringField = UILabel()
        maximumMentoringField.textColor = UIColor.red
        maximumMentoringField.text = "1 items at least"
        maximumMentoringField.font = UIFont.systemFont(ofSize: 13)
        addSubview(maximumMentoringField)
        //outsideActivityButton
        outsideActivityButton = DLRadioButton()
        outsideActivityButton.isMultipleSelectionEnabled = true
        outsideActivityButton.autoSetDimension(.width, toSize: buttonSize)
        outsideActivityButton.titleLabel?.numberOfLines = 0
        outsideActivityButton.titleLabel?.adjustsFontSizeToFitWidth = true
        outsideActivityButton.setTitle("Outside Activity", for: .normal)
        outsideActivityButton.setTitleColor(App.mainColor, for: .normal)
        
        outsideActivityButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        outsideActivityButton.contentHorizontalAlignment = .left
        
        addSubview(outsideActivityButton)
        //collegeLifeButton
        collegeLifeButton = DLRadioButton()
        collegeLifeButton.isMultipleSelectionEnabled = true
        collegeLifeButton.autoSetDimension(.width, toSize: buttonSize)
        collegeLifeButton.setTitle("College Life", for: .normal)
        collegeLifeButton.titleLabel?.numberOfLines = 0
        collegeLifeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        collegeLifeButton.setTitleColor(App.mainColor, for: .normal)
        collegeLifeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        collegeLifeButton.contentHorizontalAlignment = .left
        
        addSubview(collegeLifeButton)
        //friendAndRelationshipButton
        friendAndRelationshipButton = DLRadioButton()
        friendAndRelationshipButton.isMultipleSelectionEnabled = true
        friendAndRelationshipButton.autoSetDimension(.width, toSize: buttonSize)
        friendAndRelationshipButton.setTitle("Friend/Relationship", for: .normal)
        friendAndRelationshipButton.titleLabel?.numberOfLines = 0
        friendAndRelationshipButton.titleLabel?.adjustsFontSizeToFitWidth = true
        friendAndRelationshipButton.setTitleColor(App.mainColor, for: .normal)
        friendAndRelationshipButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        friendAndRelationshipButton.contentHorizontalAlignment = .left
        
        addSubview(friendAndRelationshipButton)
        //tripAndHobbyButton
        tripAndHobbyButton = DLRadioButton()
        tripAndHobbyButton.isMultipleSelectionEnabled = true
        tripAndHobbyButton.autoSetDimension(.width, toSize: buttonSize)
        tripAndHobbyButton.setTitle("Trip/Hobby", for: .normal)
        tripAndHobbyButton.setTitleColor(App.mainColor, for: .normal)
        
        tripAndHobbyButton.titleLabel?.numberOfLines = 0
        tripAndHobbyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        tripAndHobbyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        tripAndHobbyButton.contentHorizontalAlignment = .left
        
        addSubview(tripAndHobbyButton)
        //employmentButton
        employmentButton = DLRadioButton()
        
        employmentButton.isMultipleSelectionEnabled = true
        employmentButton.autoSetDimension(.width, toSize: buttonSize)
        employmentButton.setTitle("Employment", for: .normal)
        employmentButton.setTitleColor(App.mainColor, for: .normal)
        employmentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        employmentButton.contentHorizontalAlignment = .left
        
        addSubview(employmentButton)
        //tutoringButton
        tutoringButton = DLRadioButton()
        tutoringButton.isMultipleSelectionEnabled = true
        tutoringButton.autoSetDimension(.width, toSize: buttonSize)
        tutoringButton.setTitle("Tutoring", for: .normal)
        tutoringButton.setTitleColor(App.mainColor, for: .normal)
        tutoringButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        tutoringButton.contentHorizontalAlignment = .left
        
        addSubview(tutoringButton)
        //fashionAndBeautyButton
        fashionAndBeautyButton = DLRadioButton()
        fashionAndBeautyButton.isMultipleSelectionEnabled = true
        fashionAndBeautyButton.autoSetDimension(.width, toSize: buttonSize)
        fashionAndBeautyButton.setTitle("Fahion/Beauty", for: .normal)
        fashionAndBeautyButton.setTitleColor(App.mainColor, for: .normal)
        
        fashionAndBeautyButton.titleLabel?.numberOfLines = 0
        fashionAndBeautyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        fashionAndBeautyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        fashionAndBeautyButton.contentHorizontalAlignment = .left
        
        addSubview(fashionAndBeautyButton)
        //satAndApplicationButton
        satAndApplicationButton = DLRadioButton()
        satAndApplicationButton.isMultipleSelectionEnabled = true
        satAndApplicationButton.autoSetDimension(.width, toSize: buttonSize)
        satAndApplicationButton.setTitle("SAT/Application", for: .normal)
        satAndApplicationButton.setTitleColor(App.mainColor, for: .normal)
        satAndApplicationButton.titleLabel?.numberOfLines = 0
        satAndApplicationButton.titleLabel?.adjustsFontSizeToFitWidth = true
        satAndApplicationButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        satAndApplicationButton.contentHorizontalAlignment = .left
        
        addSubview(satAndApplicationButton)
        //mentorIntro
        mentorIntroSelf = UILabel()
        mentorIntroSelf.text = "Mentor Introduction"
        mentorIntroSelf.font = UIFont.boldSystemFont(ofSize: 17)
        addSubview(mentorIntroSelf)
        //maximimIntroSelf
        maximumIntroSelf = UILabel()
        maximumIntroSelf.textColor = UIColor.red
        maximumIntroSelf.text = "250 remaining"
        maximumIntroSelf.font = UIFont.systemFont(ofSize: 13)
        addSubview(maximumIntroSelf)
        //mentorIntroSelfTextView
        mentorIntroTextView = TextView()
        mentorIntroTextView.tag = 4
        mentorIntroTextView.placeholder = "Please, introduce yourself in detail. You can write 250 characters"
        mentorIntroTextView.layer.borderWidth = 1
        mentorIntroTextView.autoSetDimension(.height, toSize: 80.0)
        addSubview(mentorIntroTextView)
        //mentoring Info
        mentoringInfo = UILabel()
        mentoringInfo.text = "Mentoring Information"
        mentoringInfo.font = UIFont.boldSystemFont(ofSize: 17)
        addSubview(mentoringInfo)
        //maximumMentoringInfo
        maximumMentoringInfo = UILabel()
        maximumMentoringInfo.textColor = UIColor.red
        maximumMentoringInfo.text = "250 remaining"
        maximumMentoringInfo.font = UIFont.systemFont(ofSize: 13)
        addSubview(maximumMentoringInfo)
        //mentoring Info TextView
        mentoringInfoTextView = TextView()
        mentoringInfoTextView.tag = 5
        mentoringInfoTextView.placeholder = "Please, explain us how are you able to be a good mentor. You can write 250 characters"
        mentoringInfoTextView.textAlignment = .natural
        mentoringInfoTextView.layer.borderWidth = 1
        mentoringInfoTextView.autoSetDimension(.height, toSize: 80.0)
        addSubview(mentoringInfoTextView)
        //mentorCareerLabel
        mentorCareerLabel = UILabel()
        mentorCareerLabel.text = "Mentor Primary Career"
        mentorCareerLabel.font = UIFont.boldSystemFont(ofSize: 17)
        addSubview(mentorCareerLabel)
        //submit Button
        submitButton = RaisedButton()
        //submitButton.autoSetDimension(.width, toSize: self.frame.size.width - 20)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.backgroundColor = App.mainColor
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        addSubview(submitButton)
    }
}
