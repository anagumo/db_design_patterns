import UIKit

final class LoginViewController: UIViewController {
    @IBOutlet private weak var usernameTexField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
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
            case .error(message: let message):
                self?.renderError(message)
            }
        }
    }
    
    private func renderLoading() {
        loginButton.configuration?.showsActivityIndicator = true
        errorLabel.isHidden = true
    }
    
    private func renderSuccess() {
        loginButton.configuration?.showsActivityIndicator = false
    }
    
    private func renderError(_ message: String) {
        loginButton.configuration?.showsActivityIndicator = false
        errorLabel.isHidden = false
        errorLabel.text = message
    }
}
