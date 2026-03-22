# Network architecture

## VPC:10.0.0.0/16

### Public subnet (10.0.1.0/24)

- NAT Gateway for outbound internet
- internet Gateway attached
- Route 0.0.0/0
- Contains Load balancer

## Private Subnet (10.0.2.0/24)
- No direct inbound  internet access
- Contains applications servers, Dtabases

## Routing Logic
- Public subnet: Direct internet access
- Private subnet: Outbound only via NAT
- Database never exposed to internet
