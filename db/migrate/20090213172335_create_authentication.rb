class CreateAuthentication < ActiveRecord::Migration
  def self.up

    # Create Settings Table
    create_table :settings, :force => true do |t|
      t.string :label
      t.string :identifier
      t.text   :description
      t.string :field_type, :default => 'string'
      t.text   :value

      t.timestamps
    end

    # Create Users Table
    create_table :users do |t|
      t.string :login, :limit => 40
      t.string :identity_url
      t.string :name, :limit => 100, :default => '', :null => true
      t.string :email, :limit => 100
      t.string :crypted_password, :limit => 40
      t.string :salt, :limit => 40
      t.string :remember_token, :limit => 40
      t.string :activation_code, :limit => 40
      t.string :state, :null => :false, :default => 'passive'
      t.datetime :remember_token_expires_at
      t.string :password_reset_code, :default => nil
      t.datetime :activated_at
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :users, :login, :unique => true

    # Create Profile Table
    create_table :profiles do |t|
      t.references :user

      t.string :real_name
      t.string :location
      t.string :website

      t.timestamps
    end

    # Create OpenID Tables
    create_table :open_id_authentication_associations, :force => true do |t|
      t.integer :issued, :lifetime
      t.string :handle, :assoc_type
      t.binary :server_url, :secret
    end

    create_table :open_id_authentication_nonces, :force => true do |t|
      t.integer :timestamp, :null => false
      t.string :server_url, :null => true
      t.string :salt, :null => false
    end

    create_table :roles do |t|
      t.column :name, :string
    end

    # generate the join table
    create_table :roles_users, :id => false do |t|
      t.column :role_id, :integer
      t.column :user_id, :integer
    end

    # Create admin role and user
    admin_role = Role.create(:name => 'admin')

    user = User.create do |u|
      u.login = 'admin'
      u.password = u.password_confirmation = 'admin'
      u.email = 'nospam@example.com'
    end

    user.register!
    user.activate!

    user.roles << admin_role
  end

  def self.down
    # Drop all BaseApp
    drop_table :settings
    drop_table :users
    drop_table :profiles
    drop_table :open_id_authentication_associations
    drop_table :open_id_authentication_nonces
    drop_table :roles
    drop_table :roles_users
  end
end
