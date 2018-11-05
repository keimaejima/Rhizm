class Team < ApplicationRecord
	belongs_to :owner,            class_name: 'User'
 	belongs_to :plan
 	before_validation :create_stripe_customer_and_subscription, if: :new_record?

 	private

 	  # Team作成時にStripe::Customer, Stripe::Subscriptionを作成し、ひも付け
 	  def create_stripe_customer_and_subscription
 	    # Stripe::Customer 作成
 	    stripe_customer = Stripe::Customer.create(
 	      email:       owner.email,
 	      plan:        Plan::FREE_PLAN_ID,
 	      tax_percent: 8.0,
 	      metadata: {
 	        owner_id: owner.id,
 	        rails_env: Rails.env.to_s
 	      } # デバッグや管理のためmetadataを任意に追加できる
 	    )

 	    self.plan = Plan.free_plan
 	    self.stripe_customer_id = stripe_customer.id
 	    stripe_subscription = stripe_customer.subscriptions.data.first
 	    self.stripe_subscription_id = stripe_subscription.id
 	    self.active_until = Time.zone.at(stripe_subscription.current_period_end),
    end
end
