terraform {
}

resource "random_pet" "name" {
  prefix = "hashistack-diy"
  length = 1
}

# #AWS
# module "Cluster_EKS" {
#   source       = "./Cluster_EKS"
#   cluster-name = random_pet.name.id
  
# }

#MSFT
module "Cluster_AKS" {
  source       = "./Cluster_AKS"
  cluster-name = random_pet.name.id

}
# #Google
module "Cluster_GKE" {
  source       = "./Cluster_GKE"
  cluster_name = random_pet.name.id
}
