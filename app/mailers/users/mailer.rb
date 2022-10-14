class Users::Mailer < Devise::Mailer
  before_action :add_inline_attachment!

    helper :application
    include Devise::Controllers::UrlHelpers
    default template_path: 'devise/mailer'
    def confirmation_instructions(record, token, opts={})
      #record内にユーザ情報が入っていました。そこの"unconfirmed_email"の有無で登録／変更を仕分けます
      #opts属性を上書きすることで、Subjectやfromなどのヘッダー情報を変更することが可能！
      attachments.inline['confirmuser_banner.png'] = File.read('app/assets/images/confirmuser_banner.png')
      if record.unconfirmed_email != nil
        opts[:subject] = "【Dbrandscedule】メールアドレス変更手続きを完了してください"
      else
        opts[:subject] = "【Dbrandscedule】会員登録完了"
      end
      #件名の指定以外は親を継承
      super
    end

    private

  def add_inline_attachment!
    pngs = ['confirmuser_banner.png']

    pngs.each do |png|
      attachments.inline[png] = File.read("#{Rails.root}/app/assets/images/" + png)
    end
  end
  end