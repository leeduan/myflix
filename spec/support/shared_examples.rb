shared_examples 'require signin' do
  it 'redirects to the sign in page' do
    clear_current_user
    action
    expect(response).to redirect_to signin_path
  end
end

shared_examples 'redirect home current user' do
  it 'redirects to home page' do
    set_current_user
    action
    expect(response).to redirect_to home_path
  end
end

shared_examples 'generates token' do
  it 'saves a token to self' do
    expect(object.token).to be_present
  end
end