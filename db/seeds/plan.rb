Plan.create(
    stripe_plan_id: 'start-plan',
    name: 'Start Plan',
    amount: 1000,
    currency: 'jpy',
    interval: 'month',
    statement_descriptor: 'Start Plan',
)

Plan.find_each do |plan|
  Stripe::Plan.create(
    id:       plan.stripe_plan_id,
    amount:   plan.amount, # e.g. 1000
    currency: plan.currency, # e.g. 'jpy'
    interval: plan.interval, # e.g. 'month
    product: {
    	name: plan.name
  		}
  	)
end