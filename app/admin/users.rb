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

    def update
      user = resource
      # We need to bypass the attr-accessor to set the role
      user.update_attribute(:role, params[:user][:role])
      update!
    end
  end

  scope :all, :default => true
  scope I18n.t('users.role_user'),  :consumer
  scope I18n.t('users.role_agent'), :agent
  scope I18n.t('users.role_admin'), :admin

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
    column ("Set_Password") { |user| reminder_status(user.has_reset_password)}
    column("Actions")     {|user| user_links_column(user) }
  end

  show do |ad|
    rows = default_attribute_table_rows.reject {|a| a =~ /password|avatar|token|confirm/}
    attributes_table *rows do
      row(:avatar) {|u|
        image_tag(u.avatar.url('thumb')) if u.avatar?
      }
      row("Password set") { |u|
        reminder_status(u.has_reset_password)
      }
    end
  end

  form do |f|
    f.inputs do
      [:first_name, :last_name, :email].each do |field|
        f.input field
      end
      if f.object.new_record?
        f.input :send_invitation, :as => :boolean
        f.input :invitation_text, :as => :text
      end
      f.input :role, :as => :select, :collection => [[I18n.t('users.role_user'), 'user'], [I18n.t('users.role_agent'), 'agent'], [I18n.t('users.role_admin'), 'admin']], :include_blank => false

      if !f.object.new_record?
        f.input :gender, :as => :select, :collection => [[t("users.gender_male"), 'male'], [t("users.gender_female"), 'female']]
        [:birthdate, :timezone, :phone_mobile, :avatar, :passport_number, :paypal_email].each do |field|
          f.input field
        end
      end
      f.buttons
    end
  end

  #Disable User
  action_item :only => :show do
    link_to('Disable User', disable_admin_user_path(user), :method => :put,
            :confirm => "Are you sure you want to disable this user?\nNote: Doing so will unpublish all listings this user owns") if !user.disabled?
  end

  member_action :disable, :method => :put do
    user = User.find(params[:id])
    user.disable_and_unpublish_listings
    redirect_to({:action => :show}, :notice => "The user has been disabled")
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

  # Send Password Reset Reminder
  action_item :only => :show do
    if !user.has_reset_password
      link_to("Send Reminder", send_reset_password_reminder_admin_user_path(user), :method => :post,
        :confirm => 'Are you sure you want to send password reset reminder?')
    end
  end

  member_action :send_reset_password_reminder, :method => :post do
    user = User.find(params[:id])
    UserMailer.password_reset_reminder(user).deliver if user
    redirect_to({:action => :show}, :notice => "Sent password reset reminder.")
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
