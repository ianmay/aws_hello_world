resource "aws_budgets_budget" "my-monthly-budget" {
  name              = "my-monthly-budget"
  budget_type       = "COST"
  limit_amount      = "${var.monthly_budget_amount}"
  limit_unit        = "USD"
  time_period_start = "2022-11-01_00:00"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
  }
}