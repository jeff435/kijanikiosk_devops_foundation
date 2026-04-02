output "api_ip" {
  value = module.app_server["api"].public_ip
}

output "payments_ip" {
  value = module.app_server["payments"].public_ip
}

output "logs_ip" {
  value = module.app_server["logs"].public_ip
}

output "server_ips" {
  value = { for k, v in module.app_server : k => v.public_ip }
}
