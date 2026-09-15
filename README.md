terraform plan -var-file="envs/dev/terraform.tfvars"
terraform apply -var-file="envs/dev/terraform.tfvars"

terraform destroy -var-file="envs/dev/terraform.tfvars"

## 参考

https://qiita.com/ntrlmt/items/df2abeb4ab8f3cdf54b5#%E9%80%81%E4%BF%A1%E3%83%86%E3%82%B9%E3%83%88
