resource "aws_wafv2_web_acl" "alb_waf" {
  name  = "nginx-alb-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "RateLimitRule"
    priority = 1

    action {
      block {
        custom_response {
          response_code = 429
        }
      }
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name               = "RateLimitRule"
      sampled_requests_enabled  = true
    }
  }

  rule {
    name     = "AWSIPReputationList"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAmazonIpReputationList"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name               = "AWSIPReputationList"
      sampled_requests_enabled  = true
    }
  }


  rule {
    name     = "BlockOversizedRequests"
    priority = 3

    action {
      block {
        custom_response {
          response_code = 413
        }
      }
    }

    statement {
      size_constraint_statement {
        field_to_match {
          body {
            oversize_handling = "CONTINUE"
          }
        }
        comparison_operator = "GT"
        size                = 8192 # 8KB limit
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name               = "BlockOversizedRequests"
      sampled_requests_enabled  = true
    }
  }

  rule {
    name     = "GeoBlockRule"
    priority = 4
  
    action {
      block {
        custom_response {
          response_code = 403
        }
      }
    }
  
    statement {
      geo_match_statement {
        country_codes = ["IL"] 
      }
    }
  
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name               = "GeoBlockRule"
      sampled_requests_enabled  = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name               = "nginx-alb-waf"
    sampled_requests_enabled  = true
  }

  tags = {
    Name        = "nginx-alb-waf"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

resource "aws_wafv2_web_acl_association" "alb_waf_association" {
  resource_arn = aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.alb_waf.arn
}