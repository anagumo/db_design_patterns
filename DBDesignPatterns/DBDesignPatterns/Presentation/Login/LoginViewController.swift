import UIKit

final class LoginViewController: UIViewController {
    // MARK: UI Components
    @IBOutlet private weak var usernameTexField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    private let loginViewModel: LoginViewModel
    
    // MARK: Lifecycle
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
        super.init(nibName: "LoginView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    // Add functionality to handle user interaction and hide the keyboard.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: UI Operations
    @IBAction func onLoginButtonTapped(_ sender: UIButton) {
        loginViewModel.login(
            username: usernameTexField.text,
            password: passwordTextField.text
        )
    }
    
    // MARK: Binding
    private func bind() {
        loginViewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .loading:
                self?.renderLoading()
            case .success:
                self?.renderSuccess()
            case let .error(loginError):
                self?.renderError(loginError)
            }
        }
    }
    
    private func renderLoading() {
        loginButton.configuration?.showsActivityIndicator = true
        usernameErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
    }
    
    private func renderSuccess() {
        loginButton.configuration?.showsActivityIndicator = false
        navigationController?.setViewControllers([HomeBuilder().build()], animated: true)
    }
    
    private func renderError(_ loginError: LoginError) {
        loginButton.configuration?.showsActivityIndicator = false
        
        switch loginError.regex {
        case .email:
            usernameErrorLabel.isHidden = false
            usernameErrorLabel.text = loginError.regex?.errorDescription
        case .password:
            passwordErrorLabel.isHidden = false
            passwordErrorLabel.text = loginError.regex?.errorDescription
        default:
            // Display an alert when the error is not related to any text field
            renderAlert(errorMessage: loginError.reason)
        }
    }
    
    private func renderAlert(errorMessage: String) {
        present(
            AlertBuilder().build(title: "Error", message: errorMessage),
            animated: true
        )
    }
}
