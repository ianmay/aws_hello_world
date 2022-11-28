resource "aws_budgets_budget" "hello_world_budget" {
  name              = "hello_world_${var.budget.time_span}-budget"
  budget_type       = "COST"
  limit_amount      = var.budget.amount
  limit_unit        = "USD"
  time_unit         = var.budget.time_span
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = var.budget.email
  }
}