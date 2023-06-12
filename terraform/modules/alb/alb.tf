odule "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "my-alb"

  load_balancer_type = "application"

  vpc_id             = "vpc-abcde012"
  subnets            = ["subnet-abcde012", "subnet-bcde012a"]
  security_groups    = ["sg-edcd9784", "sg-edcd9785"]

  target_groups = [
    {
      backend_protocol = "HTTP"
      backend_port     = 443
      target_type      = "instance"
      targets = {
        my_target = {
          target_id = "wpserver1"
          port = 443
        }
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      target_group_index = 0
    }
  ]
}