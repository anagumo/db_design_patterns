import UIKit
import OSLog

final class LoginViewController: UIViewController {
    // MARK: UI Components
    @IBOutlet private weak var usernameTexField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - View Model
    private let loginViewModel: LoginViewModel
    
    // MARK: Lifecycle
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
        super.init(nibName: "LoginView", bundle: Bundle(for: type(of: self)))
    }
    
    // Required because we added a custom init, but is not necessary initialize the controller from IB
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    // MARK: UI Operations
    // Add functionality to handle user interaction and hide the keyboard.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func onLoginButtonTapped(_ sender: UIButton) {
        Logger.debug.log("On login button tapped")
        loginViewModel.login(
            username: usernameTexField.text,
            password: passwordTextField.text
        )
    }
    
    // MARK: Binding
    /// Implements a listener of view model events and data binding
    private func bind() {
        loginViewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .loading:
                self?.renderLoading()
            case .success:
                self?.renderSuccess()
            case let .fullScreenError(message):
                self?.renderFullScreenError(message)
            case let .inlineError(regexLintError):
                self?.renderInlineError(regexLintError)
            }
        }
    }
    
    // MARK: - State Rendering
    private func renderLoading() {
        loginButton.configuration?.showsActivityIndicator = true
        usernameErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
    }
    
    private func renderSuccess() {
        loginButton.configuration?.showsActivityIndicator = false
        navigationController?.setViewControllers([HomeBuilder().build()], animated: true)
    }
    
    private func renderFullScreenError(_ message: String) {
        loginButton.configuration?.showsActivityIndicator = false
        
        present(
            AlertBuilder().build(title: "Error", message: message),
            animated: true
        )
    }
    
    private func renderInlineError(_ regexLintError: RegexLintError) {
        loginButton.configuration?.showsActivityIndicator = false
        
        switch regexLintError {
        case .email:
            usernameErrorLabel.isHidden = false
            usernameErrorLabel.text = regexLintError.errorDescription
        case .password:
            passwordErrorLabel.isHidden = false
            passwordErrorLabel.text = regexLintError.errorDescription
        }
    }
}
