###VGW##
resource "aws_vpn_gateway" "vgw" {
  vpc_id = var.vpc-id
  tags = {
   Name        = "vgw-${var.name}"
   Client = var.client
   Domain = var.domain
   Environment = var.environment
    }
}

### get details of route tables ### this can be part of
data "aws_route_tables" "rts" {
  vpc_id = var.vpc-id
#  vpc_id = module.vpc.vpc_id

  filter {
      name = "tag-value"
      values = ["*private*"]
    }

   filter {
      name = "tag-key"
      values = ["Name"]
    }
}


#VPN# ROUTES PROPAGATIONS

# Route Propagations for Private Subnets
resource "aws_vpn_gateway_route_propagation" "vgw-private-routes" {
#  count = length(data.aws_availability_zones.azs.names)
  count = length(data.aws_availability_zones.available.names)
  vpn_gateway_id = aws_vpn_gateway.vgw.id
#  route_table_id = element(var.vgw-private-route-table-id,count.index)
  route_table_id  = tolist(data.aws_route_tables.rts.ids)[count.index]
} 

