ActiveAdmin.register User do
  menu :priority => 1
  actions :all, :except => [:destroy]

  controller do
    helper 'admin/users'

    def new
      @user = User.new

      # Transport some extra data in the form
      @user.class_eval do
        attr_accessor :send_invitation
        attr_accessor :invitation_text
      end
      @user.invitation_text = I18n.t('mailers.auto_welcome.content')
      new!
    end

    def create
      @user = User.new
      @user.class_eval do
        attr_accessor :send_invitation
        attr_accessor :invitation_text
      end

      @user.attributes = params[:user]

      @user.send_invitation = params[:user][:send_invitation]
      @user.invitation_text = params[:user][:invitation_text]

      if @user.save_without_password
        if @user.send_invitation == '1'
          UserMailer.auto_welcome(@user, @user.invitation_text).deliver
          flash[:success] = "User created."
        else
          flash[:success] = "User created and invitation sent."
        end

        redirect_to admin_user_path(@user)
      else
        respond_with @user
      end
    end
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
    rows = default_attribute_table_rows.reject {|a| a =~ /password|avatar|token|confirm/}
    attributes_table *rows do
      row(:avatar) {|u|
        image_tag(u.avatar.url('thumb')) if u.avatar?
      }
    end
  end

  form do |f|
    f.inputs do
      [:first_name, :last_name, :email].each do |field|
        f.input field
      end
      if f.object.new_record?
        f.input :role, :as => :select, :collection => [['Consumer', 'user'], ['Agent', 'agent']]
        f.input :send_invitation, :as => :boolean
        f.input :invitation_text, :as => :text
      end

      if !f.object.new_record?
        f.input :gender, :as => :select, :collection => [[t("users.gender_male"), 'male'], [t("users.gender_female"), 'female']]
        [:birthdate, :timezone, :phone_mobile, :avatar, :passport_number].each do |field|
          f.input field
        end
      end
      f.buttons
    end
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

  # Take control
  action_item :only => :show do
    link_to('Take Control', take_control_admin_user_path(user), :method => :post) if !user.admin?
  end

  member_action :take_control, :method => :post do
    target_user = User.find(params[:id])
    if target_user
      current_admin_user.take_control(target_user)
      sign_in_and_redirect current_admin_user.user
    end
  end

  collection_action :release_control, :method => :post do
    current_admin_user.release_control
    redirect_to admin_users_path
  end

  action_item :only => :index do
    link_to('Invite from CSV', invite_csv_admin_users_path)
  end

  collection_action :invite_csv, :method => :get do
    render 'admin/invitations/import'
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
