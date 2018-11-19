module V1
class Stripe_API < Grape::API
 resource "stripes" do
  get do
     "get test"
  end
   # params do
   #   requires :challenge
   # end
  post do
      begin
        user = User.create(id: User.last.id + 1, email: params[:stripeEmail])
        stripe_customer = Stripe::Customer.create(
          email:       params[:stripeEmail],
          metadata: {
            user_id: user.id,
            rails_env: Rails.env.to_s
          } # デバッグや管理のためmetadataを任意に追加できる
        )

        stripe_customer = Stripe::Customer.retrieve(stripe_customer.id)
        stripe_customer.source = params[:stripeToken] # Stripe.jsで変換したトークンを渡すだけ
        stripe_customer.save

        subscription = Stripe::Subscription.create(
          :customer => stripe_customer.id,
          :items => [
            {
              :plan => params[:plan_id],
            },
          ]
        )
        p subscription
        UserMailer.welcome_email(user).deliver_later
      rescue => e
        Rails.logger.fatal(Settings.alert.occured_in_api)
        Rails.logger.fatal(e)
      end
  end
end
end
end