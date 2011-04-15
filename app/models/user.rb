# encoding: utf-8
# == Schema Information
# Schema version: 20110410074008
#
# Table name: users
#
#  id         :integer(4)      not null, primary key
#  email      :string(255)
#  name       :string(255)
#  password   :string(255)
#  salt       :string(255)
#  admin      :boolean(1)
#  actived    :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#
require 'digest'

class User < ActiveRecord::Base

  #定义属性可访问性
  attr_accessible :email,:name,:password,:password_confirmation
  #定义关系
  #
  #用户可能操作多个需要激活码的动作 1:n
  has_many :active_codes, :foreign_key => "email", :primary_key => 'email'

  #邮箱校验正则表达式
  email_regex = /\A[(a-z\d)+\-.]+@[(a-z\d)]+\.[(a-z\d)]+\z/i

  validates :name, :presence => true,
                    :length => {:within => 6..40}
  validates :email, :presence => true,
                    :format => {:with => email_regex},
                    :uniqueness => {:case_sensitive => false}
  validates :password, :presence => true,
                       #需要确认
                       :confirmation => true,
                       :length => { :within => 6..20 }
  #before_save函数调用，在保存某个用户前进行密码的加密
  before_save :encrypt_password

  public 
    def has_password?(submitted_password)
      encrypted_password == encrypt(submitted_password)
    end
    
    #对用户的邮箱和密码进行校验
    def self.authenticate(email,submitted_password)
      #根据邮箱查找用户，邮箱是唯一的。
      user = find_by_email(email)
      #没有找到用户,返回nil
      return nil if user.nil?
      #返回密码匹配后的用户
      return user if user.has_password?(submitted_password)
    end

    #对用户id和cookie中的噪声进行验证
     def self.authenticate_with_salt(id,cookie_salt)
       user = find_by_id(id)
       (user && user.salt == cookie_salt)? user:nil
     end

    private
      #加密密码，如果是更新密码，则不重新制造噪声
      def encrypt_password
        self.salt = make_salt if new_record? #如果是新插入的值，进行噪声的初始化
        self.password = encrypt(password)
      end
      
      #加密字符串
      def encrypt(string)
        secure_hash("#{salt}--#{string}")
      end
      
      #制造噪声
      def make_salt
        secure_hash("#{Time.now.utc}--#{password}")
      end

      #使用SHA2加密算法，进行加密,得到不可逆的哈希值
      def secure_hash (string)
        Digest::SHA2.hexdigest(string)
      end
end
