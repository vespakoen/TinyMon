class LoginViewController < Formotion::FormController
  def init
    initWithForm(build_form)
    self.title = "Login"
    @form.on_submit do |form|
      submit(form)
    end
    self
  end
  
  def submit(form)
    login_data = form.render
    RemoteModule::RemoteModel.root_url = "http://#{login_data.delete(:server)}/"
    
    session = UserSession.new(login_data)
    session.login do |response, json|
      Account.current_account_id = json["attempted_record"]["current_account_id"]
      UIApplication.sharedApplication.delegate.window.rootViewController = LoggedInViewDeckController.alloc.init
    end
  end

private
  def build_form
    @form ||= Formotion::Form.persist({
      persist_as: :credentials,
      sections: [{
        rows: [{
          title: "Email",
          key: :email,
          placeholder: "me@mail.com",
          type: :email,
          auto_correction: :no,
          auto_capitalization: :none
        }, {
          title: "Password",
          key: :password,
          placeholder: "required",
          type: :string,
          secure: true
        }]
      }, {
        title: "Server",
        rows: [{
          title: "Host name",
          value: "mon.tinymon.org",
          key: :server,
          type: :string,
        }]
      }, {
        rows: [{
          title: "Login",
          type: :submit,
        }]
      }]
    })
  end
end
