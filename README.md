terraform plan -var-file="envs/dev/terraform.tfvars"
terraform apply -var-file="envs/dev/terraform.tfvars"

terraform destroy -var-file="envs/dev/terraform.tfvars"

## トラブル
・ドメインにアクセスできない
    →dnsキャッシュ？が原因だったっぽい
    https://zenn.dev/takahashim/articles/cd9d8f17dbcb71

## 参考

https://qiita.com/ntrlmt/items/df2abeb4ab8f3cdf54b5#%E9%80%81%E4%BF%A1%E3%83%86%E3%82%B9%E3%83%88

### 【Terraform】既存リソースを取り込むためのimportブロックを試してみる
https://iret.media/84378

### Terraform の整合性問題を解決！3つのシナリオ別対処法
https://zenn.dev/nakashi94/articles/8680b05ef5c2f8#%E3%82%B7%E3%83%8A%E3%83%AA%E3%82%AA2%3A-%E6%97%A2%E5%AD%98%E3%83%AA%E3%82%BD%E3%83%BC%E3%82%B9%E3%81%AE-terraform-%E7%AE%A1%E7%90%86%E3%81%B8%E3%81%AE%E7%A7%BB%E8%A1%8C


・route53のimport
terraform import -var-file="envs/dev/terraform.tfvars" \
    aws_route53_record.test Z05944281ASU7750FXSPU_test.dosaken.org_A

