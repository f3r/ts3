ActiveAdmin.register User do
  menu :priority => 1
  actions :all, :except => [:create, :new, :destroy]

  controller do
    helper 'admin/users'
  end

  scope :all, :default => true
  scope :consumer
  scope :agent
  scope :admin

  filter :email
  filter :first_name
  filter :last_name
  filter :created_at

  index do |place|
    id_column
    column :email
    column :full_name
    column(:role)         {|user| status_tag(user.role) }
    column :created_at
    column :confirmed_at
    column :last_sign_in_at
    column("Actions")     {|user| user_links_column(user) }
  end

  show do |ad|
    rows = default_attribute_table_rows.reject {|a| a =~ /password|avatar/}
    attributes_table *rows do
      row(:avatar) {|u|
        image_tag(u.avatar.url('thumb')) if u.avatar?
      }
    end
  end

  form do |f|
    f.inputs :email, :first_name, :last_name, :gender, :birthdate, :timezone, :phone_mobile, :avatar, :passport_number
    f.buttons
  end

  # Make Agent
  action_item :only => :show do
    link_to('Make Agent', make_agent_admin_user_path(user), :method => :put,
      :confirm => 'Are you sure you want to turn the user into an agent?') if user.consumer?
  end

  member_action :make_agent, :method => :put do
    user = User.find(params[:id])
    user.update_attribute(:role, 'agent')
    redirect_to({:action => :show}, :notice => "The user is now an agent")
  end

  # Make Admin
  action_item :only => :show do
    link_to('Make Admin', make_admin_admin_user_path(user), :method => :put,
      :confirm => 'Are you sure you want to turn the user into an admin?') if !user.admin?
  end

  member_action :make_admin, :method => :put do
    user = User.find(params[:id])
    user.update_attribute(:role, 'admin')
    redirect_to({:action => :show}, :notice => "The user is now an admin")
  end

  action_item :only => :index do
    link_to('New Invitation', invite_admin_users_path)
  end

  action_item :only => :index do
    link_to('Invite from CSV', invite_csv_admin_users_path)
  end

  collection_action :invite, :method => :get do
    render 'admin/invitations/new'
  end

  collection_action :invite_csv, :method => :get do
    render 'admin/invitations/import'
  end

  collection_action :send_invitation, :method => :post do
    user = User.auto_signup(params[:invitation][:name], params[:invitation][:email], params[:invitation][:role], params[:invitation][:message])
    if user.persisted?
      flash[:success] = "Invitations sent"
    else
      flash[:error] = "There was an error sending the invitation"
    end
    redirect_to :action => :index
  end

  collection_action :import_invitations, :method => :post do
    if !params[:invitation] || !params[:invitation][:file]
      flash[:success] = "You must select a file"
      redirect_to :action => :invite
    else
      list = CsvImport.to_hashes(params[:invitation][:file])
      count = User.send_invitations(list, params[:invitation][:role], params[:invitation][:message])
      if count > 0
        flash[:success] = "#{count} Invitations sent"
        redirect_to :action => :index
      else
        flash[:error] = "No invitations were sent"
        redirect_to :action => :invite
      end
    end
  end
end
