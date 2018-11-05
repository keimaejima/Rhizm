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

      # stripe_subscription = Stripe::Subscription.retrieve(stripe_customer.id)
      # stripe_subscription.plan = Plan.find(params[:plan_id])
      # stripe_subscription.save
      Stripe::Subscription.create(
        :customer => stripe_customer.id,
        :items => [
          {
            :plan => params[:plan_id],
          },
        ]
      )
  end
end
end
end