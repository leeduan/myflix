shared_examples "require_signin" do
  it 'redirects to the sign in page' do
    clear_current_user
    action
    expect(response).to redirect_to signin_path
  end
end