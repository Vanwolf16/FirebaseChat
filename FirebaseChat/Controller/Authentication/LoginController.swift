//
//  LoginController.swift
//  FirebaseChat
//
//  Created by David Murillo on 5/26/23.
//

import UIKit


protocol AuthenicationDelegate:AnyObject{
    func authenticationComplete()
}

class LoginController: UIViewController {
    
   private var viewModel = LoginViewModel()
    
    weak var delegate: AuthenicationDelegate?
    
    //MARK: Properties
    private let iconImage:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bubble.right")
        iv.tintColor = .white
        return iv
    }()
    
    private let passwordTextField = CustomTextField(placeholder: "Password")
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private lazy var emailContainerView:InputContainerView = {
        return InputContainerView(image: UIImage(systemName: "envelope")!, textField: emailTextField)
    }()
    
    private lazy var passwordContainerView:InputContainerView = {
        return InputContainerView(image: UIImage(systemName: "lock")!, textField: passwordTextField)
    }()
    
    private let loginButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemRed
        button.setHeight(height: 50)
        button.isEnabled = false
        return button
    }()
    
    private let dontHaveAccountButton:UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Sign Up!", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17),NSAttributedString.Key.foregroundColor:UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: Selector
    @objc func handleLogIn(){
        
        guard let email = emailTextField.text,let passsword = passwordTextField.text else {return}
        
        AuthService.shared.logUserIn(withEmail: email,password: passsword) { result, error in
            if let error = error{
                print("Failed to login user: \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true,completion: nil)
            self.delegate?.authenticationComplete()
        }
        
    }
    
    @objc func handleShowSignUp(){
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender:UITextField){
        
        if sender == emailTextField{
            viewModel.email = sender.text
        }else{
            viewModel.password = sender.text
        }
        checkFormStatus()
    }
    
    //MARK: Helper
    func configureUI(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .systemPink
        setUpGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top:view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
        iconImage.setDimensions(height: 120, width: 120)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView,loginButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top:iconImage.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,
                     paddingTop: 32,paddingLeft: 32,paddingRight: 32)
        
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left:view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,paddingLeft: 32,paddingBottom: 16,
                                     paddingRight: 32)
        //textfield action
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    private func checkFormStatus(){
        if viewModel.formIsValid{
            loginButton.isEnabled = true
            loginButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }else{
            loginButton.isEnabled = false
            loginButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
    
    func setUpGradientLayer(){
        let graident = CAGradientLayer()
        graident.colors = [UIColor.systemPurple.cgColor,UIColor.systemPink.cgColor]
        graident.locations = [0,1]
        view.layer.addSublayer(graident)
        graident.frame = view.frame
    }
    
}
